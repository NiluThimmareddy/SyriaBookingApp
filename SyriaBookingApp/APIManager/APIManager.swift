//
//  APIManager.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 25/07/25.
//

import UIKit

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case invalidResponse
    case serverError(statusCode: Int, data: String)
    case userNotFound
    case EnterValidData
    case sessionExpired
    case unauthorized
    case custom(String)
    
    
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
        case .serverError(_, let message):
            return message
        case .userNotFound:
            return "User not found  rom apimanager"
        case .EnterValidData:
            return "Enter valid data"
        case .custom(let message):
            return message
            
            
        case .sessionExpired:
            return "Session expired pleas Login again"
        case .unauthorized:
            return " Unauthorized"
        }
    }
}

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func fetchData<T: Decodable>(from url: URL,requiresJWT:Bool = false,modelType: T.Type,completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if requiresJWT {
            do {
                try AuthManager.shared.authorize(request: &request)
            } catch {
                completion(.failure(error))
                return
            }
        }else{
            request.setValue(APIConstants.apiKey, forHTTPHeaderField: APIConstants.headerAPIKey)
        }
        
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
                        
                        completion(.failure(NetworkError.userNotFound))
                        return
                    }

                    if let data = data,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {

                        completion(.failure(NetworkError.custom(errorResponse.message)))
                        return
                    }

                    let message = String(data: data ?? Data(), encoding: .utf8) ?? "Something went wrong."
                    completion(.failure(NetworkError.custom(message)))
                    return
                }

            } else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
               
                completion(.success(decodedData))
            }

            catch {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func postRequest<T: Codable>(urlString: URL,body: [String: Any],responseType: T.Type, urlencoded : Bool? = nil,  requiresJWT: Bool = false ,completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Invalid Body", code: -2)))
            return
        }
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        
        if requiresJWT {
            do {
                try AuthManager.shared.authorize(request: &request)
            } catch {
                completion(.failure(error))
                return
            }
        }else{
            request.setValue(APIConstants.apiKey, forHTTPHeaderField: APIConstants.headerAPIKey)
        }
        
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
                print("❌ Decoding Error:", error)

                   if let json = String(data: data, encoding: .utf8) {
                       print("📦 Response JSON:")
                       print(json)
                   }
                completion(.failure(error))
            }
        }.resume()
    }
    
    func putRequest<T: Codable>(urlString: URL, body: [String: Any], responseType: T.Type, requiresJWT:Bool = false, completion: @escaping (Result<T, Error>) -> Void) {
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
        
        if requiresJWT {
            do {
                try AuthManager.shared.authorize(request: &request)
            } catch {
                completion(.failure(error))
                return
            }
        }else{
            request.setValue(APIConstants.apiKey, forHTTPHeaderField: APIConstants.headerAPIKey)
        }
        
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
                completion(.failure(NetworkError.invalidResponse))
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
                
                let message = String(data: data ?? Data(), encoding: .utf8) ?? "Something went wrong."
                completion(.failure(NetworkError.serverError(
                    statusCode: httpResponse.statusCode,
                    data: message
                )))
                return
            }
            
            guard let data = data else {
                print("🔴 No Data in Response")
                completion(.failure(NetworkError.noData))
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
                completion(.failure(NetworkError.decodingFailed))
            }
        }.resume()
    }
}
