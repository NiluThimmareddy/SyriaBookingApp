//
//  LoginViewModel.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 21/07/26.
//

import Foundation

final class LoginViewModel{
    private let apicalClient: APIClient
    
    init(apicalClient: APIClient = .shared) {
        self.apicalClient = apicalClient
    }
    
    func checkMobile(_ mobile: String) async throws -> CheckMobileResponse {
        
     let request = CheckMobileRequest(mobile: mobile)
        
        return try await apicalClient.send(
            endpoint: .checkMobile,
            body: request,
            responseType: CheckMobileResponse.self
        )
    }
    
    func sendOtp(_ mobile: String) async throws -> OTPResponseModel {
        
        let request = SendMobileOTPRequest(mobile: mobile)
        
        return try await apicalClient.send(
            endpoint: .sentOTP,
            body: request,
            responseType: OTPResponseModel.self)
    }
    
    func verifyOTP(_ mobile: String, otp: String) async throws -> VerifyLoginResponse {
        
        let request = VerifyMobileOTPRequest(mobile: mobile, code: otp)
        
        return try await apicalClient.send(
            endpoint: .verifyOTP,
            body: request,
            responseType: VerifyLoginResponse.self)
    }
    
    func sendRegistrationEmailOTP( email : String) async throws -> OTPResponseModel{
        let request = sendRegestrationEmailOTPRequest(email: email)
           
           return try await apicalClient.send(
               endpoint: .sendNewUserOTP,
               body: request,
               responseType: OTPResponseModel.self
           )
       }
    
    func verifyRegistrationEmailOTP( email : String, otp: String) async throws -> VerifyRegistrationEmailOTPResponse{
        let request = VerifyEmailOtpRequest(email: email, code: otp)
        
        return try await apicalClient.send(
            endpoint: .verifyNewUserEmailOTP,
            body: request,
            responseType: VerifyRegistrationEmailOTPResponse.self
        )
    }
    
    func senEmailOtp(email:String) async throws -> OTPResponseModel {
        let request = SendEmailOtpRequest(email: email)
        
        return try await apicalClient.send(
            endpoint: .sendEmailOTP,
            body: request,
            responseType: OTPResponseModel.self
            )
    }
    
    func verifyEmailOTP( email : String, otp: String) async throws -> VerifyLoginResponse{
        let request = VerifyEmailOtpRequest(email: email, code: otp)
        
        return try await apicalClient.send(
            endpoint: .verifyEmailOTP,
            body: request,
            responseType: VerifyLoginResponse.self
        )
    }
    
}
extension Endpoint {
    static let checkMobile = Endpoint(
        path: APIURL.checkMobile.url,
        method: .post,
        authentication: .none
    )
    
    static let sentOTP = Endpoint(
        path: APIURL.postForOTP.url,
        method: .post,
        authentication: .none)
    
    static let verifyOTP = Endpoint(
        path: APIURL.verifyOTP.url,
        method: .post,
        authentication: .none)
    
    static let sendEmailOTP = Endpoint(
        path: APIURL.postForEmailOTP.url,
        method: .post,
        authentication: .none)
    
    static let verifyEmailOTP = Endpoint(
        path: APIURL.verifyEmailOTP.url,
        method: .post,
        authentication: .none)
    
    static let sendNewUserOTP = Endpoint(
        path: APIURL.postForNewUserOTP.url,
        method: .post,
        authentication: .none)
    
    static let verifyNewUserEmailOTP = Endpoint(
        path: APIURL.verifyNewUserOTP.url,
        method: .post,
        authentication: .none)
    
}

