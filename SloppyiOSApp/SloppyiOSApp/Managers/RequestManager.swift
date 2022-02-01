//
//  RequestManager.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 8.08.21.
//

import Foundation
import Alamofire

class RequestManager: NSObject {
    static let standard = RequestManager()
    static let dataQueue = DispatchQueue(label: "Data queue", qos: .default)


    class func register(credentials: [String:String], completion: ((_ success: Bool?, _ error: Error?)-> Void)? = nil) {
        Alamofire.request(API.register, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: API.contentHeader).response { response in//.validate().responseJSON { response in
            guard response.error == nil else {
                completion?(false, response.error)
                return
            }
            guard  let data = response.data, let responseValue = String(data: data, encoding: .utf8) else {
                completion?(false, SloppyError.cannotParseRegisterResponse)
                return
            }

            if responseValue.lowercased().contains("success") {
                completion?(true,nil)
            } else {
                completion?(false, SloppyError.emailAlreadyInUse)
            }
        }
    }

    class func login(credentials: [String:String], completion: ((_ success: Bool, _ error: Error?)-> Void)? = nil) {
        Alamofire.request(API.authentication, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: credentials).response { response in
            guard response.error == nil else {
                completion?(false, response.error)
                return
            }
            
            guard  let data = response.data, let stringUid = String(data: data, encoding: .utf8), let userID = Int(stringUid), let authToken = response.response?.allHeaderFields["Authtoken"] as? String else {
                completion?(false, SloppyError.cannotParseResponse)
                return
            }

            dataQueue.async {
                let user = User(userID: userID, email: credentials["email"] ?? "", plantIds: [], sharedPlantIds: [])
                UserDefaultsData.userEmail = credentials["email"] ?? ""
                UserDefaultsData.userPassword = credentials["password"] ?? ""
                UserDefaultsData.isUserLoggedIn = true
                UserDefaultsData.token = authToken
                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
                LocalDataManager.addData(user, update: true, realm: realm)
                LocalDataManager.addData(user, update: true, realm: realm)
                completion?(true, nil)
            }
        }
    }

    class func userProfile(completion: ((_ success: Bool, _ error: Error?)-> Void)? = nil) {
        guard let userId = [User](LocalDataManager.realm.objects(User.self)).first?.userID else { return }
        Alamofire.request(API.userProfile(with: userId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
            guard response.error == nil else {
                completion?(false, response.error)
                return
            }
            
            guard response.result.error == nil else {
                completion?(false, response.result.error)
                return
            }
            
            //MARK: - Continue later
        }
    }

//    class func fetchMainPlants(completion: ((_ success: Bool,_ error: Error?)-> Void)? = nil) {
//        Alamofire.request(API.fetchAllMainPlants, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
//            guard response.error == nil else {
//                completion?(false, response.error)
//                return
//            }
//
//            guard response.result.error == nil else {
//                completion?(false, response.result.error)
//                return
//            }
//
//            guard let responseDict = response.result.value as? [String:Any] else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dataDict = responseDict["data"] as? [[String:Any]]  else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            dataQueue.async {
//                var mainPlantArray: [MainPlant] = [MainPlant]()
//                for data in dataDict {
//                    let mainPlant = MainPlant(json: data)
//                    mainPlantArray.append(mainPlant)
//                }
//                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
//                LocalDataManager.addData(mainPlantArray, update: true, realm: realm)
//                DispatchQueue.main.async {
//                    completion?(true, nil)
//                }
//            }
//        }
//    }
//
//    class func fetchOwnedAndSharedPlaintIds(completion: ((_ success: Bool,_ error: Error?)-> Void)? = nil) {
//
//        Alamofire.request(API.fetchOwnedAndSharedPlantIds, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
//            guard response.error == nil else {
//                completion?(false, response.error)
//                return
//            }
//
//            guard response.result.error == nil else {
//                completion?(false, response.result.error)
//                return
//            }
//
//            guard let responseDict = response.result.value as? [String:Any] else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dataDict = responseDict["data"] as? [String:Any], let plantIds = dataDict["plantIds"] as? [String], let sharedPlantIds = dataDict["sharedPlantIds"] as? [String]  else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            dataQueue.async {
//                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
//                guard let user = realm.objects(User.self).first else { return }
//                realm.beginWrite()
//                for plantId in plantIds {
//                    user.plantIds.append(plantId)
//                }
//
//                for sharedPlantId in sharedPlantIds {
//                    user.sharedPlantsIds.append(sharedPlantId)
//                }
//                try? realm.commitWrite()
//                LocalDataManager.addData(user, update: true, realm: realm)
//            }
//        }
//    }
//
//
//    class func fetchOwnedAndSharedPlaints(completion: ((_ success: Bool,_ error: Error?)-> Void)? = nil) {
//        Alamofire.request(API.fetchOwnedAndSharedPlants, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
//            guard response.error == nil else {
//                completion?(false, response.error)
//                return
//            }
//
//            guard response.result.error == nil else {
//                completion?(false, response.result.error)
//                return
//            }
//
//            guard let responseDict = response.result.value as? [String:Any] else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dataDict = responseDict["data"] as? [[String:Any]]  else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            dataQueue.async {
//                var plantArray: [Plant] = [Plant]()
//                for data in dataDict {
//                    guard let dictionary = data["userPlant"] as? [String:Any] else {
//                        completion?(false, SloppyError.cannotParseResponse)
//                        return
//                    }
//                    let plant = Plant(json: dictionary)
//                    plantArray.append(plant)
//                }
//                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
//                LocalDataManager.addData(plantArray, update: true, realm: realm)
//                DispatchQueue.main.async {
//                    completion?(true, nil)
//                }
//            }
//
//        }
//    }
//
//    class func sharePlantViaEmail(dictionary: [String: String], completion: ((_ message: String,_ error: Error?)-> Void)? = nil) {
//        Alamofire.request(API.sharePlantViaEmail, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
//            guard response.error == nil else {
//                completion?("", response.error)
//                return
//            }
//
//            guard response.result.error == nil else {
//                completion?("", response.result.error)
//                return
//            }
//
//            guard let responseDict = response.result.value as? [String:Any] else {
//                completion?("", SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dataDict = responseDict["data"] as? [String:Any]  else {
//                completion?("", SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let messageString = dataDict["message"] as? String else {
//                completion?("", SloppyError.cannotParseResponse)
//                return
//            }
//
//            completion?(messageString, nil)
//        }
//    }
//
//    class func unsharPlantViaEmail(dictionary: [String: String], completion: ((_ message: String,_ error: Error?)-> Void)? = nil) {
//        Alamofire.request(API.unsharePlantViaEmail, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
//            guard response.error == nil else {
//                completion?("", response.error)
//                return
//            }
//
//            guard response.result.error == nil else {
//                completion?("", response.result.error)
//                return
//            }
//
//            guard let responseDict = response.result.value as? [String:Any] else {
//                completion?("", SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dataDict = responseDict["data"] as? [String:Any]  else {
//                completion?("", SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let messageString = dataDict["message"] as? String else {
//                completion?("", SloppyError.cannotParseResponse)
//                return
//            }
//
//            completion?(messageString, nil)
//        }
//    }
//
//    class func waterPlant(plantId: String, completion: ((_ success: Bool,_ error: Error?)-> Void)? = nil) {
//        let dictionary = ["plantId" : plantId]
//        Alamofire.request(API.waterPlant, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
//            guard response.error == nil else {
//                completion?(false, response.error)
//                return
//            }
//
//            guard response.result.error == nil else {
//                completion?(false, response.result.error)
//                return
//            }
//
//            guard let responseDict = response.result.value as? [String:Any] else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dataDict = responseDict["data"] as? [String:Any]  else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            dataQueue.async {
//                let plant = Plant(json: dataDict)
//                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
//                LocalDataManager.addData(plant, update: true, realm: realm)
//                DispatchQueue.main.async {
//                    completion?(true, nil)
//                }
//            }
//        }
//    }
//
//    class func sendNewPlantInformation(dictionary: [String:Any], completion: ((_ success: Bool,_ error: Error?)-> Void)? = nil) {
//        Alamofire.request(API.addOwnPlant, method: .post, parameters: dictionary , encoding: JSONEncoding.default, headers: API.commonHeaders).validate().responseJSON { response in
//            guard response.error == nil else {
//                completion?(false, response.error)
//                return
//            }
//
//            guard response.result.error == nil else {
//                completion?(false, response.result.error)
//                return
//            }
//
//            guard let responseDict = response.result.value as? [String:Any] else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dataDict = responseDict["data"] as? [String:Any]  else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            guard let dictionary = dataDict["userPlant"] as? [String:Any] else {
//                completion?(false, SloppyError.cannotParseResponse)
//                return
//            }
//
//            dataQueue.async {
//                let plant = Plant(json: dictionary)
//                let realm = LocalDataManager.backgroundRealm(queue: dataQueue)
//                LocalDataManager.addData(plant, update: true, realm: realm)
//                DispatchQueue.main.async {
//                    completion?(true, nil)
//                }
//            }
//        }
//    }
}

