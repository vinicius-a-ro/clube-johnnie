//
//  NetworkManager.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/6/16.
//  Copyright © 2016 Bydoo. All rights reserved.
//

import Foundation
import Alamofire

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

public typealias NetworkResult = (json: JSON?, error: NSError?) -> ()

public enum Method: String {
    case GET
    case POST
    case DELETE
    case PUT
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

public class NetworkManager {
    
//--------------------------------------------------
// MARK: - Properties
//--------------------------------------------------
    
    public static let sharedInstance = NetworkManager()
    public static var baseURL: String = ""
    
    public func request(requestType: Method,
                        url: String,
                        parameters: [String : AnyObject]? = nil,
                        completion: NetworkResult) {
        
        let url = "\(NetworkManager.baseURL)/\(url)"
        let method = Alamofire.Method(requestType)
        
        Alamofire.request(method, url, parameters: parameters)
            .responseJSON { response in
            completion(json: JSON(data: response.data), error: response.result.error)
        }
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Alamofire.Method Compability
//
//----------------------------------------------------------------------------------------------------------

extension Alamofire.Method {
    init(_ method: Method) {
        switch method {
        case .GET: self = .GET
        case .POST: self = .POST
        case .DELETE: self = .DELETE
        case .PUT: self = .PUT
        }
    }
}