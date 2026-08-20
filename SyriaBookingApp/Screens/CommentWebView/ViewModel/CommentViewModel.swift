//
//  CommentViewModel.swift
//  SyriaBookingApp
//
//  Created by Toqsoft on 05/08/26.
//


import Foundation

class CommentViewModel {

    
    func fetchComment(completion: @escaping (Result<[CommentModel], Error>) -> Void) {

        guard let url = URL(string: "https://storagehotelbooking.z1.web.core.windows.net/response.json") else {
            print("Invalid Comment URL")
            return
        }
        
        APIManager.shared.fetchData(from: url, modelType: [CommentModel].self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
