//
//  User.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 11.08.21.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var userID: String = ""
    @objc dynamic var email: String = ""
    var plantIds: List<String> = List<String>()
    var sharedPlantsIds: List<String> = List<String>()

    override init() {}
    
    init(userID: String, email: String, plantIds: [String], sharedPlantIds: [String]) {
        super.init()
        self.userID = userID
        self.email = email
        for plantId in plantIds {
            self.plantIds.append(plantId)
        }
        for sharedPlantId in sharedPlantIds {
            self.sharedPlantsIds.append(sharedPlantId)
        }
    }

    static override func primaryKey() -> String? {
        return "userID"
    }
}
