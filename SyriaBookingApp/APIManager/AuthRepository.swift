//
//  AuthRepository.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 17/07/26.

/*
final class AuthRepository {
    private let apiClient: APIClient
    private let tokenStore: KeychainTokenStore
    private let sessionManager: SessionManager
    
    init(
        apiClient: APIClient,
        tokenStore: KeychainTokenStore,
        sessionManager: SessionManager
    ) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.sessionManager = sessionManager
    }
    
    func sendExistingUserOtp(email: String) async throws {
        let endpoint = Endpoint(
            path: "api/UserPublic/send-email-otp",
            method: .post,
            authentication: .none
        )
        
        let _: EmptyResponse = try await apiClient.send(
            endpoint: endpoint,
            body: SendEmailOtpRequest(email: email),
            responseType: EmptyResponse.self
        )
    }
    
    func verifyExistingUserOtp(
        email: String,
        otp: String
    ) async throws {
        let endpoint = Endpoint(
            path: "api/UserPublic/verify-email-otp",
            method: .post,
            authentication: .none
        )
        
        let login = try await apiClient.send(
            endpoint: endpoint,
            body: VerifyEmailOtpRequest(
                email: email,
                code: otp
            ),
            responseType: LoginResponse.self
        )
        try tokenStore.saveSession(
            token: login.token,
            expiresAtUtc: login.expiresAtUtc,
            userId: login.userId,
            email: login.email
        )
        await MainActor.run {
            sessionManager.markAuthenticated()
        }
    }
    func verifyRegistrationOtp(
        email: String,
        otp: String
    ) async throws -> Bool {
        let endpoint = Endpoint(
            path:
                "api/UserPublic/verify-registration-email-otp",
            method: .post,
            authentication: .none
        )
        let result = try await apiClient.send(
            endpoint: endpoint,
            body: VerifyEmailOtpRequest(
                email: email,
                code: otp
            ),
            responseType:
                RegistrationVerifyResponse.self
        )
        // No JWT is returned or stored here.
        return result.isVerified
    }
}
struct EmptyResponse: Decodable {}
*/


import Foundation

final class AuthManager {

    static let shared = AuthManager()

    private let tokenStore = KeychainTokenStore()

    private init() {}

    func authorize(request: inout URLRequest) throws {

        if tokenStore.isTokenExpired() {
            throw NetworkError.sessionExpired
        }

        guard let token = tokenStore.token(),
              !token.isEmpty else {
            throw NetworkError.sessionExpired
        }

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )
    }
}
