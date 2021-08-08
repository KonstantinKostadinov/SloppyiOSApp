//
//  RequestManager.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 8.08.21.
//

import Foundation
import Alamofire


enum SloppyError: Error {
    case cannotParseRegisterReponse
}

public class API: URLConvertible {
    let stringCall: String

    var baseURL: String {
        return "ngrokshit"
    }

    public init(_ value: String) {
        assert(value.first != "/", "url paths should not start with \'/\'")
        self.stringCall = value
    }

    public func asURL() throws -> URL {
        return URL(string: baseURL + self.stringCall)!
    }
}

extension API {
    static let register = API("backend/users/register")
    static let login = API("backend/users/login")
    static let me = API("backend/users/me")
    static let fetchAllPlants = API("backend/plants/allPlants")
}

class RequestManager: NSObject {
    static let standard = RequestManager()
    static let updateDataQueue = DispatchQueue(label: "Update data queue", qos: .userInteractive)

    class func register(credentials: [String:String], completion: ((_ success: Bool?, _ error: Error?)-> Void)? = nil) {
        Alamofire.request(API.register, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            guard response.error == nil else {
                completion?(false, response.error)
                return
            }
            
            guard response.result.error == nil else {
                completion?(false, response.result.error)
                return
            }

            guard let responseDict = response.result.value as? [String:Any], let dataDict = responseDict["data"] else {
                completion?(false, SloppyError.cannotParseRegisterReponse)
                return
            }

            print("reponse dict: ", dataDict)
            
        }
    }

    class func login(credentials: [String:String], completion: ((_ success: Bool, _ error: Error?)-> Void)? = nil) {
        Alamofire.request(API.login, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            guard response.error == nil else {
                completion?(false, response.error)
                return
            }
            
            guard response.result.error == nil else {
                completion?(false, response.result.error)
                return
            }

            guard let responseDict = response.result.value as? [String:Any], let dataDict = responseDict["data"] else {
                completion?(false, SloppyError.cannotParseRegisterReponse)
                return
            }

            print("reponse dict: ", dataDict)
        }
    }
}

