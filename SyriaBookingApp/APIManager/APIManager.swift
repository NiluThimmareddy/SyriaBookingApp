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
                    completion(.failure(APIError.serverError(httpResponse.statusCode)))
                    return
                }
            } else {
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
}
