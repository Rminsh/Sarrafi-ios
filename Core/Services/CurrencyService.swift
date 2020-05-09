//
//  CurrencyService.swift
//  Sarrafi
//
//  Created by armin on 5/8/20.
//  Copyright © 2020 shalchian. All rights reserved.
//

import Foundation
import Alamofire

class CurrencyService {
    
    static let shared = CurrencyService()
    private init() {}
    
    func getList(completion: @escaping (CurrencyListResponse?, Error?)-> Void) throws {
        
        /**
         Currency List
         get http://call.tgju.org/ajax.json
         */
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = . reloadIgnoringLocalAndRemoteCacheData
        
        var req = URLRequest(url: URL(string: "https://call.tgju.org/ajax.json")!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // Fetch Request
        AF.request(req)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(nil, NetworkingError.badNetworkingRequest)
                        return
                    }
                    do {
                        let decoder = try JSONDecoder().decode(CurrencyStruct.self, from: data)
                        let result = CurrencyListResponse(currencyStruct: decoder)
                        completion(result, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkingError.errorParse)
                    }
                case .failure:
                    completion(nil, NetworkingError.badNetworkingRequest)
                }
        }
    }
}
