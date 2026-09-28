//
//  AuthRepository.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 17/07/26.

import Foundation

final class AuthManager {

    static let shared = AuthManager()

    private let tokenStore = KeychainTokenStore()

    private init() {}

    func authorize(request: inout URLRequest) throws {

        if tokenStore.isTokenExpired() {
            UserSessionManager.clearUser()
            throw NetworkError.sessionExpired
        }

        guard let token = tokenStore.token(),
              !token.isEmpty else {
            UserSessionManager.clearUser()
            throw NetworkError.sessionExpired
        }

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )
    }
}
