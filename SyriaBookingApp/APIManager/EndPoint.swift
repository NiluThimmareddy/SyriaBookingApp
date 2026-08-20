//
//  EndPoint.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 17/07/26.
//

import Foundation
enum AuthenticationType{
    case none
    case jwt
    case apiKey
}

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint{
    let path: URL
    let method: HTTPMethod
    let authentication: AuthenticationType
}
