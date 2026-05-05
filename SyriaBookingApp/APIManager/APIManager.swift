//
//  APIManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case invalidResponse
    case serverError
    case userNotFound
   case EnterValidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data returned from server."
        case .decodingFailed:
            return "Something went wrong. Please try again."
        case .invalidResponse:
            return "Invalid server response."
        case .serverError:
            return "Server error. Please try later."
        case .userNotFound:
            return "User not found"
        case .EnterValidData:
            return "Enter valid data"
        
            
        }
    }
}

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func fetchData<T: Decodable>(from url: URL,modelType: T.Type,completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
#if DEBUG
                        print("fetchData APIMAnager : \(error)")
#endif
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == 404 {
                        completion(.failure(APIError.userNotFound))
                        return
                    }else{
                        completion(.failure(APIError.serverError))
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
                
                completion(.failure(APIError.decodingFailed))
            }
        }
        task.resume()
    }
    
    func postRequest<T: Codable>(urlString: URL,body: [String: Any],responseType: T.Type, urlencoded : Bool? = nil ,completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Invalid Body", code: -2)))
            return
        }
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        
        if let  urlencoded = urlencoded , urlencoded == true{
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let bodyString = body
                .map { "\($0.key)=\(($0.value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
                    .joined(separator: "&")

                request.httpBody = bodyString.data(using: .utf8)
        } else{
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        }

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
    
    func putRequest<T: Codable>(urlString: URL, body: [String: Any], responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Invalid Body", code: -2)))
            return
        }
#if DEBUG
        print("🟢 PUT URL:", urlString)
        print("🟡 Request Body:", body)
#endif
        var request = URLRequest(url: urlString)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
#if DEBUG
                print("🔴 Network Error:", error.localizedDescription)
#endif
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("🔴 Invalid Response")
                completion(.failure(APIError.invalidResponse))
                return
            }
           
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
#if DEBUG
                    print("🟣 Server Response:", responseString)
                
#endif
                }
                
#if DEBUG
                print("🔵 Response Code:", httpResponse.statusCode)
                
#endif
                completion(.failure(APIError.serverError))
                return
            }
            
            guard let data = data else {
                print("🔴 No Data in Response")
                completion(.failure(APIError.noData))
                return
            }
            if let responseString = String(data: data, encoding: .utf8) {
#if DEBUG
                print("🟣 Response Data:", responseString)
#endif
            }
            
            do {
                let decoded = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decoded))
            } catch {
#if DEBUG
                print("🔴 Decoding Failed:", error)
#endif
                completion(.failure(APIError.decodingFailed))
            }
        }.resume()
    }
}
