//
//  LocalDataManager.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 2.09.21.
//

import Foundation
import RealmSwift

enum LocalDataManagerError: Error {
    case wrongQueue
}

class LocalDataManager {

    static let realm: Realm = {
        return try! initializeRealm(checkForMainThread: true)
    }()

    static func backgroundRealm(queue: DispatchQueue = DispatchQueue.main) -> Realm {
        return try! initializeRealm(checkForMainThread: false, queue: queue)
    }

    class func initializeRealm(checkForMainThread: Bool = false, queue: DispatchQueue = DispatchQueue.main) throws -> Realm {
           if checkForMainThread {
               guard OperationQueue.current?.underlyingQueue == DispatchQueue.main else {
                   throw LocalDataManagerError.wrongQueue
               }
           }
           do {
               return try Realm(configuration: realmConfiguration, queue: queue)
           } catch {
               throw error
           }
       }

    static let realmConfiguration: Realm.Configuration = {
        var configuration = Realm.Configuration.defaultConfiguration

        configuration.schemaVersion = 2
        configuration.migrationBlock = { (migration, version) in

        }

        return configuration
    }()

    class func getData<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        self.realm.refresh()

        return predicate == nil ? self.realm.objects(type) : self.realm.objects(type).filter(predicate!)
    }

    class func getDataByKey<T: Object>(_ type: T.Type, key: String) -> T? {
        self.realm.refresh()

        return realm.object(ofType: type, forPrimaryKey: key)
    }

    class func addData<T: Object>(_ data: [T], update: Bool = true, realm: Realm = LocalDataManager.realm) {

        realm.refresh()

        var policy: Realm.UpdatePolicy = .error

        if update {
            policy = .all
        }

        if realm.isInWriteTransaction {
            realm.add(data, update: policy)
        } else {
            try? realm.write {
                realm.add(data, update: policy)
            }
        }
    }

    class func addData<T: Object>(_ data: T, update: Bool = true, realm: Realm = LocalDataManager.realm ) {
        addData([data], update: update, realm: realm)
    }

    class func delete<T: Object>(_ data: [T], realm: Realm = LocalDataManager.realm) {
        realm.refresh()
        do {
            try realm.write { realm.delete(data) }

        } catch {
            print("Failed to delete object 😧")
        }

    }

    class func delete<T: Object>(_ data: T, realm: Realm = LocalDataManager.realm) {
        delete([data], realm: realm)
    }

    class func dropDatabase() {
        DispatchQueue.main.async {
            try? LocalDataManager.realm.write {
                LocalDataManager.realm.deleteAll()
            }
        }
    }
}

enum SyncState: String {
    case notSynched
    case synching
    case synched
}
