//
//  ProfileViewModel.swift
//  SyriaBookingApp
//
//  Created by toqsoft on 09/10/25.
//

import Foundation

class ProfileViewModel {
    
    var onProfileUpdated: ((Bool, String?, BookingModel?) -> Void)?
    var onError: ((String) -> Void)?
    
    func updateProfile(userId: String, profile: BookingModel) {
        guard let url = APIURL.updateProfile(userId: userId).url else {
            onProfileUpdated?(false, "Invalid URL", nil)
            return
        }
        
        let body: [String: Any] = [
            "name": profile.name,
            "mobile": profile.mobile,
            "address": profile.address,
            "gender": profile.gender,
            "email": profile.email,
            "country": profile.country,
            "dob": profile.dob
        ]
        
        APIManager.shared.putRequest(urlString: url, body: body, responseType: ProfileResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.onProfileUpdated?(true, "Profile updated successfully.", response.data)
                case .failure(let error):
                    self?.onProfileUpdated?(false, "Failed to update profile: \(error.localizedDescription)", nil)
                }
            }
        }
    }
}
