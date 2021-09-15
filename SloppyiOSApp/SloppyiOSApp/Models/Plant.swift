//
//  Plant.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 1.09.21.
//

import Foundation
import RealmSwift

class Plant: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var parentId: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var timesPlantIsWatered: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var lastTimeWatered: Double = 0
    @objc dynamic var daysToWater: Int = 0
    @objc dynamic var plantMainParent: String = ""
    var assignedToFriendsWithIds: List<String> = List<String>()

    override init() {}
    
    convenience init(id: String, parentId: String, notes: String, timesPlantIsWatered: Int, name: String, lastTimeWatered: Double, daysToWater: Int, assignedToFriendsWithIds: [String], plantMainParent: String) {
        self.init()
        self.id = id
        self.parentId = parentId
        self.notes = notes
        self.timesPlantIsWatered = timesPlantIsWatered
        self.name = name
        self.lastTimeWatered = lastTimeWatered
        self.daysToWater = daysToWater
        self.plantMainParent = plantMainParent
        for friendId in assignedToFriendsWithIds {
            self.assignedToFriendsWithIds.append(friendId)
        }
    }

    convenience init(json: [String:Any]) {
        self.init()
        self.id = json["id"] as? String ?? ""
        self.notes = json["notes"] as? String ?? ""
        self.timesPlantIsWatered = json["timesPlantIsWatered"] as? Int ?? 0
        self.name = json["name"] as? String ?? ""
        self.lastTimeWatered = json["lastTimeWatered"] as? Double ?? 0
        self.daysToWater = json["daysToWater"] as? Int ?? 0
        let assignedToFriendsWithIds = json["assignedToFriendsWithIds"] as? [String] ?? [String]()
        for friendId in assignedToFriendsWithIds {
            self.assignedToFriendsWithIds.append(friendId)
        }
        self.plantMainParent = json["plantMainParent"] as? String ?? ""
//        guard let parentIdDict = json["parentUser"] as? [String:Any] else { return }
        self.parentId = ""//parentIdDict["id"] as? String ?? ""
    }
    static override func primaryKey() -> String? {
        return "id"
    }
}
