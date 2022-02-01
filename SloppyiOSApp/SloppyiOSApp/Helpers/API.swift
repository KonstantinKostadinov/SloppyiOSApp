//
//  API.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 2.02.22.
//

import Foundation
import Alamofire

enum SloppyError: Error {
    case cannotParseRegisterResponse
    case nilSharedPlantsOROwnedPlants
    case cannotParseResponse
    case emailAlreadyInUse
}

public class API: URLConvertible {
    let stringCall: String

    var baseURL: String {
        return "https://plant-app-spring-backend.herokuapp.com/v.1.0/api/"
    }

    public init(_ value: String) {
        assert(value.first != "/", "url paths should not start with \'/\'")
        self.stringCall = value
    }

    public func asURL() throws -> URL {
        return URL(string: baseURL + self.stringCall)!
    }

    static let contentHeader: [String:String] = ["Content-Type" : "application/json"]
    static let commonHeaders: [String: String] = ["Content-Type" : "application/json",
                                            "Authorization" : "Bearer \(UserDefaultsData.token)"]
}

extension API {
    static let ping = API("user/ping")
    static let register = API("user/registration")
    static let authentication = API("user/authentication")
    static let me = API("user/profile")
    static let fetchAllPlants = API("plants/allPlants")
    static let fetchAllMainPlants = API("plants/all")
    static let fetchOwnedAndSharedPlantIds = API("userPlants/ownedAndSharedPlants")
    static let fetchOwnedAndSharedPlants = API("userPlants/returnOwnedAndSharedPlants")
    static let sharePlantViaEmail = API("userPlants/shareMyPlant")
    static let unsharePlantViaEmail = API("userPlants/unshareMyPlant")
    static let waterPlant = API("userPlants/waterPlant")
    static let addOwnPlant = API("userPlants/addOwnPlant")
}

extension API {
    class func userProfile(with id: Int) -> API {
        return API("user/profile/\(id)")
    }
}
