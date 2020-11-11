//
//  GorestService.swift
//  PlayerTracker
//
//  Created by Elisabet Massó on 10/11/2020.
//

import Foundation

class GorestService {
    
    private let host = "gorest.co.in"
    
    /**
     GET call to Gorest API with path "/public-api/users"
      
     - Parameters:
        - userId: Parameter to use in call.
        - success: Block-code to run if call is sucess. Called with a `GorestDataModel` object.
        - failure: Block-code to run if call is failure. Called with a `String`.
     */
    func getUser(by userId: String,
                 success: (@escaping ( GorestDataModel? ) -> Void),
                 failure: (@escaping ( String ) -> Void)) {
        
        doGETRequest(parameters: ["id": userId],
                     path: "/public-api/users",
                     success: success,
                     failure: failure)
        
    }
    
    /**
     HTTP call to Gorest API"
      
     - Parameters:
        - parameters: Parameters to use in call.
        - path: The path of the request.
        - success: Block-code to run if call is sucess. Called with a `T` object.
        - failure: Block-code to run if call is failure. Called with a `String`.
     */
    private func doGETRequest<T:Decodable>(parameters: [String: String],
                                           path: String,
                                           success: (@escaping ( T? ) -> Void),
                                           failure: (@escaping ( String ) -> Void)) {
        
        doRequest(parameters: parameters,
                  path: path,
                  success: success,
                  failure: failure)
        
    }
    
    /**
     HTTP call to Gorest API"
      
     - Parameters:
        - parameters: Parameters to use in call.
        - path: The path of the request.
        - success: Block-code to run if call is sucess. Called with a `T` object.
        - failure: Block-code to run if call is failure. Called with a `String`.
     */
    private func doRequest<T:Decodable>(parameters: [String: String],
                                        path: String,
                                        success: (@escaping ( T? ) -> Void),
                                        failure: (@escaping ( String ) -> Void)) {
        
        /// Building the URL.
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        urlBuilder.queryItems = []
        for param in parameters {
            urlBuilder.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
        }
        
        guard let url = urlBuilder.url else {
            return failure("Invalid resource URL")
        }
        
        /// Converting the URL to `URLRequest` for the call.
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "GET"
        requestURL.allHTTPHeaderFields = ["ContentType": "application/json"]
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                /// Filtering the response is valid.
                guard error == nil else {
                    failure("Failed request from Gorest: \(error!.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    failure("No data returned from Gorest")
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    failure("Unable to process Gorest response")
                    return
                }
                
                guard response.statusCode == 200 else {
                    failure("Failure response from Gorest: \(response.statusCode)")
                    return
                }
                
                do {
                    /// Decoding tha data to the object model.
                    let result = try JSONDecoder().decode(T.self, from: data)
                    success(result)
                } catch {
                    failure("Unable to decode Gorest response")
                }
                
            }
            
        }
        
        dataTask.resume()
        
    }
    
}
