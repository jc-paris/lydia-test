//
//  UserService.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

enum UserServiceError: Error {
    case invalidData
    case invalidUser
    
    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "Invalid response format"
        case .invalidUser:
            return "Invalid user in API response"
        }
    }
}

class UserService {
    static let baseURL = "https://randomuser.me/api/1.2/?seed=lydia"
    
    static func fetchUser(page: Int, count: Int, completion: @escaping ([UserResult]?, Error?) -> Void) {
        
        Alamofire.request("\(UserService.baseURL)&results=\(count)&page=\(page)")
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    guard let results = json["results"].array else {
                        completion(nil, UserServiceError.invalidData)
                        return
                    }
                    var users = [UserResult]()
                    for result in results {
                        guard let user = UserResult(json: result) else {
                            completion(nil, UserServiceError.invalidUser)
                            return
                        }
                        users.append(user)
                    }
                    completion(users, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
}
