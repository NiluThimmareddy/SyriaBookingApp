//
//  boookingSupportAssistent.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 26/05/26.
//

import Foundation

enum ChatIntent{
    case viewBoooking
    case cancelBooking
    case refundStatus
    case invoice
    case unknown
}

struct ChatMessages : Identifiable {
    let id = UUID()
    let text : String
    let isUser: Bool
    
}

func  decodeChatIntent(message: String) -> ChatIntent{
    let text = message.lowercased()
    
    if text.contains("booking") {
        return .viewBoooking
    }
    
    if text.contains("cancel"){
        return .cancelBooking
    }
    
    if text.contains("refund"){
        return .refundStatus
    }
    
    if text.contains("invoice"){
        return .invoice
    }
    
    return .unknown
}
