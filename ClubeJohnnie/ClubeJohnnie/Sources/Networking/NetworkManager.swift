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

public typealias NetworkResult = (_ json: JSON?, _ error: Error?) -> ()

public enum Method: String {
    case get
    case post
    case delete
    case put
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

open class NetworkManager {
    
//--------------------------------------------------
// MARK: - Properties
//--------------------------------------------------
    
    open static let sharedInstance = NetworkManager()
    open var baseURLString: String = ""
    
    open func request(_ type: Method,
                        url: String,
                        parameters: [String : AnyObject]? = nil,
                        completion: @escaping NetworkResult) {
        
        let url = "\(NetworkManager.sharedInstance.baseURLString)\(url)"
        let method = Alamofire.HTTPMethod(type)
        
        Alamofire.request(url, method: method, parameters: parameters)
            .responseJSON { response in
                
            let responseJSON = JSON(data: response.data)
            if responseJSON["success"].boolValue {
                completion(responseJSON["data"], response.result.error)
            }
            else {
                // TODO: handle error
            }
        }
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Alamofire.Method Compability
//
//----------------------------------------------------------------------------------------------------------

extension Alamofire.HTTPMethod {
    init(_ method: Method) {
        switch method {
        case .get: self = .get
        case .post: self = .post
        case .delete: self = .delete
        case .put: self = .put
        }
    }
}
