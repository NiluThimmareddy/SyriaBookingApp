//
//  BookingViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 22/08/25.
//

import Foundation

class BookingViewModel{
    
    var onSuccess: ((BookingModel) -> Void)?
    var onError: ((String) -> Void)?
    
    func FetchUserData(mobile:String){
        
        guard let urlstr = APIURL.BookingURL.url?.absoluteString else { return }
        let getUrl = urlstr + "/mobile/\(mobile)"
        
        let url = URL(string: getUrl)
        
        guard let url = url else{
            self.onError?("Invalid URL")
            return
        }
        
        APIManager.shared.fetchData(from: url, modelType: BookingResponse.self) { result  in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.onSuccess?(success.data)
                    print(success)
                case .failure(let failure):
                    if case APIError.userNotFound = failure{
                        self.onError?("User not found")
                    }else{
                        
                        self.onError?(failure.localizedDescription)
                        print(failure.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    func SubmitBookingInfo(name: String, mobile: String, address: String = "", gender: String, email: String, country: String, dob: String)
    {

        let params: [String: Any] = [
            "name": name,
            "mobile": mobile,
            "address": address,
            "gender": gender,
            "email": email,
            "country": country,
            "dob": dob
        ]
        
        guard let url =  APIURL.BookingURL.url else {
            self.onError?("Invalid URL")
            return
        }
        
       APIManager.shared.postRequest(urlString: url , body: params, responseType: BookingModel.self) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
                    self.onSuccess?(response)
                case .failure(let failure):
                    self.onError?(failure.localizedDescription)
                }
            }
        }
    }
    
    func loadCountries(completion: @escaping ([CountryModel]) -> Void) {
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "countries_with_lengths", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            do {
                let countries = try JSONDecoder().decode([CountryModel].self, from: data)
                DispatchQueue.main.async {
                    completion(countries)
                }
            } catch {
                print("Decoding error:", error)   
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
}
