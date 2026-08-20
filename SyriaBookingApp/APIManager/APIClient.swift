//
//  APIClient.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 17/07/26.
//

import Foundation

final class APIClient {
    static let shared = APIClient(
            tokenStore: KeychainTokenStore()
        )

        private let session: URLSession
        private let tokenStore: KeychainTokenStore

        init(
            session: URLSession = .shared,
            tokenStore: KeychainTokenStore
        ) {
            self.session = session
            self.tokenStore = tokenStore
        }

      
    // MARK: - Request with Response

    func send<Response: Decodable, Body: Encodable>(
        endpoint: Endpoint,
        body: Body?,
        responseType: Response.Type
    ) async throws -> Response {

        var request = URLRequest( url:  endpoint.path)
        

        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
        }

        // Authentication
        switch endpoint.authentication {

        case .none:
            break

        case .jwt:
            
            do {
                    try AuthManager.shared.authorize(request: &request)
                } catch {
                    await expireSession()
                    throw error
                }

        case .apiKey:

            request.setValue(
                APIConstants.apiKey,
                forHTTPHeaderField: "X-API-KEY"
            )
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        

        if httpResponse.statusCode == 401 {
            await expireSession()
            throw NetworkError.unauthorized
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            
#if DEBUG
    print("🔴 Status Code:", httpResponse.statusCode)
    if let json = String(data: data, encoding: .utf8) {
        print("🔴 Response:", json)
    }
#endif
            
            if let errorResponsemsg = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.custom(errorResponsemsg.message)
            }
            
            let message = String(data: data, encoding: .utf8) ?? "Something went wrong."
            
            throw NetworkError.custom(message)
        }

        do {
            return try JSONDecoder().decode(
                Response.self,
                from: data
            )
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    // MARK: - Request without Body

    func send<Response: Decodable>(
        endpoint: Endpoint,
        responseType: Response.Type
    ) async throws -> Response {

        try await send(
            endpoint: endpoint,
            body: Optional<EmptyBody>.none,
            responseType: responseType
        )
    }

    // MARK: - Request with No Content (204)

    func send(
        endpoint: Endpoint
    ) async throws {

        var request = URLRequest(url: endpoint.path)
        

        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")

        switch endpoint.authentication {

        case .none:
            break

        case .jwt:

            if tokenStore.isTokenExpired() {
                await expireSession()
                throw NetworkError.sessionExpired
            }

            guard let token = tokenStore.token(),
                  !token.isEmpty else {
                await expireSession()
                throw NetworkError.sessionExpired
            }

            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )

        case .apiKey:

            request.setValue(
                APIConstants.apiKey,
                forHTTPHeaderField: "X-API-KEY"
            )
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if httpResponse.statusCode == 401 {
            await expireSession()
            throw NetworkError.unauthorized
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            
#if DEBUG
    print("🔴 Status Code:", httpResponse.statusCode)
    if let json = String(data: data, encoding: .utf8) {
        print("🔴 Response:", json)
    }
#endif
            
            if let errorResponsemsg = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.custom(errorResponsemsg.message)
            }
            
            let message = String(data: data, encoding: .utf8) ?? "Something went wrong."
            
            throw NetworkError.custom(message)
        }
    }

    // MARK: - Logout

    private func expireSession() async {

        tokenStore.clearSession()
       
        await MainActor.run {
            NotificationCenter.default.post(name: .sessionExpired, object: nil)
        }
    }
}

struct EmptyBody: Encodable {}

struct ErrorResponse : Codable {
    let message : String
}
