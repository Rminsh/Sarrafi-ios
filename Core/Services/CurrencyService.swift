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
    
    func getList(completion: @escaping (Result<CurrencyListResponse, NetworkingError>)-> Void) {
        
        /**
         Currency List
         get http://call.tgju.org/ajax.json
         */
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        var request = URLRequest(url: URL(string: "https://call.tgju.org/ajax.json")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // Fetch Request
        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
						completion(.failure(.connectionIssue))
                        return
                    }
					
                    do {
                        let currencyStruct = try JSONDecoder().decode(CurrencyStruct.self, from: data)
                        let result = CurrencyListResponse(currencyStruct: currencyStruct)
						completion(.success(result))
                    } catch {
                        print(error)
						completion(.failure(.parsingError))
                    }
                case .failure:
					completion(.failure(.connectionIssue))
                }
        }
    }
	
	
}
