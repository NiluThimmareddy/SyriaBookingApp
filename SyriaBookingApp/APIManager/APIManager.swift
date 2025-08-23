//
//  APIManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

enum APIError: Error {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case invalidResponse
    case serverError(Int)
    case userNotFound
}

class APIManager {
    static let shared = APIManager()
    
   
    
    private init() {}
    
    func fetchData<T: Decodable>(from url: URL,modelType: T.Type,completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == 404 {
                        completion(.failure(APIError.userNotFound))
                        return
                    }else{
                        completion(.failure(APIError.serverError(httpResponse.statusCode)))
                        return
                    }
                }
                
               
                
            }  else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIError.decodingFailed(error)))
            }
        }
        task.resume()
    }
    
    func postRequest<T: Codable>(
        urlString: URL,
        body: [String: Any],
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Invalid Body", code: -2)))
            return
        }
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -3)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
