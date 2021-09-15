//
//  MainPlant.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 1.09.21.
//

import Foundation
import RealmSwift

class MainPlant: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var origin: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var scientificName: String = ""
    @objc dynamic var maxGrowth: String = ""
    @objc dynamic var poisonousToPets: String = ""
    @objc dynamic var temperature: String = ""
    @objc dynamic var light: String = ""
    @objc dynamic var watering: String = ""
    @objc dynamic var soil: String = ""
    @objc dynamic var rePotting: String = ""
    @objc dynamic var airHumidity: String = ""
    @objc dynamic var propagation: String = ""
    @objc dynamic var whereItGrowsBest: String = ""
    @objc dynamic var potentialProblems: String = ""
    
    override init() { }
    convenience init(id: String, origin: String, name: String, scientificName: String, maxGrowth: String, poisonousToPets: String, temperature: String, light: String, watering: String, soil: String, rePotting: String, airHumidity: String, propagation: String, whereItGrowsBest: String, potentialProblems: String) {
        self.init()
        self.id = id
        self.origin = origin
        self.name = name
        self.scientificName = scientificName
        self.maxGrowth = maxGrowth
        self.poisonousToPets = poisonousToPets
        self.temperature = temperature
        self.light = light
        self.watering = watering
        self.soil = soil
        self.rePotting = rePotting
        self.airHumidity = airHumidity
        self.propagation = propagation
        self.whereItGrowsBest = whereItGrowsBest
        self.potentialProblems = potentialProblems
    }

    convenience init(json: [String:Any]) {
        self.init()
        self.id = json["id"] as? String ?? ""
        self.origin = json["origin"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.scientificName = json["scientificName"] as? String ?? ""
        self.maxGrowth = json["maxGrowth"] as? String ?? ""
        self.poisonousToPets = json["poisonousToPets"] as? String ?? ""
        self.temperature = json["temperature"] as? String ?? ""
        self.light = json["light"] as? String ?? ""
        self.watering = json["watering"] as? String ?? ""
        self.soil = json["soil"] as? String ?? ""
        self.rePotting = json["rePotting"] as? String ?? ""
        self.airHumidity = json["airHumidity"] as? String ?? ""
        self.propagation = json["propagation"] as? String ?? ""
        self.whereItGrowsBest = json["whereItGrowsBest"] as? String ?? ""
        self.potentialProblems = json["potentialProblems"] as? String ?? ""
    }
    
    var json: [String:Any] {
        var dict = [String:Any]()
         dict["id"] = self.id
        dict["origin"] = self.origin
        dict["name"] = self.name
        dict["scientificName"] = self.scientificName
        dict["maxGrowth"] = self.maxGrowth
        dict["poisonousToPets"] = self.poisonousToPets
        dict["temperature"] = self.temperature
        dict["light"] = self.light
        dict["watering"] = self.watering
        dict["soil"] = self.soil
        dict["rePotting"] = self.rePotting
        dict["airHumidity"] = self.airHumidity
        dict["propagation"] = self.propagation
        dict["whereItGrowsBest"] = self.whereItGrowsBest
        dict["ipotentialProblemsd"] = self.potentialProblems
        return dict
    }

    static override func primaryKey() -> String? {
        return "id"
    }
}
