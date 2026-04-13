//
//  CareerApplicationViewModel.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 14/01/26.
//

import Foundation
class CareerApplicationViewModel {
    
    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    func SubmitCareerInfo(ApplicantName: String, ApplicantEmail: String, ApplicantPhone: String, ApplicantCity: String, AppliedFor: String, CoverMessage: String, CvFile: String) {
        let params: [String: Any] = [
            "ApplicantName": ApplicantName,
            "ApplicantEmail": ApplicantEmail,
            "ApplicantPhone": ApplicantPhone,
            "ApplicantCity": ApplicantCity,
            "AppliedFor": AppliedFor,
            "CoverMessage": CoverMessage,
            "CvFile": CvFile
        ]
        
        guard let url = APIURL.Applycareer.url else {
            self.onError?("Invalid URL")
            return
        }
        
        APIManager.shared.postRequest(urlString: url,body: params,responseType: ReporAnAppModel.self,urlencoded: true) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.onSuccess?(response.message)
                case .failure(let failure):
                    self.onError?(failure.localizedDescription)
                }
            }
        }
    }
}
