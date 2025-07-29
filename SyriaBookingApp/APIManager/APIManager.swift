//
//  APIManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import Foundation

enum APIError : Error {
    case invalidURL
    case decodingFailed
    case noData
    
    
}

class APIManager{
    static let shared = APIManager()
    
    private init(){
    }
    
    func fetchData<T : Decodable>(from url:URL, modeltType:T.Type, completion: @escaping (Result<T, Error>) -> Void){
        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
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
                completion(.failure(APIError.decodingFailed))
            }
        }
        task.resume()
    }
}
