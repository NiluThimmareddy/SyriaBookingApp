//
//  BookingViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 22/08/25.
//

import Foundation

class BookingViewModel{
    
    var onSuccess: ((BookingModel) -> Void)?
    var onPostBookingSuccess : ((PostBookingResponse) -> Void)?
    var onError: ((String) -> Void)?
    var onVerifyOTPSucess : ((VerifyOTPModel) -> Void)?
    func FetchUserData(mobile:String? = nil,id:String? = nil){
        
        guard let urlstr = APIURL.BookingURL.url?.absoluteString else { return }
        var getUrl = ""
        if let mobile = mobile, !mobile.isEmpty {
             getUrl = urlstr + "/mobile/\(mobile)"
        } else if let id = id, !id.isEmpty{
            getUrl = urlstr + "/\(id)"
        }else{
            self.onError?("Enter valid data")
        }
        
       
        
        
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
    
    var onOTPSuccess: ((OTPResponseModel) -> Void)?
    
    func fetchOTP(mobileNumber:String){
        
        guard let urlstr = APIURL.postForOTP.url?.absoluteString else { return }
//        let getUrl = urlstr + "\(mobileNumber)"
        
        let url = URL(string: urlstr)
        
        guard let url = url else{
            self.onError?("Invalid URL")
            return
        }
        
        let params: [String: Any] = [
            "mobile": mobileNumber,
        ]
        
        APIManager.shared.postRequest(urlString: url , body: params, responseType: OTPResponseModel.self) { result in
             DispatchQueue.main.async{
                 switch result {
                 case .success(let response):
                     self.onOTPSuccess?(response)
                 case .failure(let failure):
                     self.onError?(failure.localizedDescription)
                 }
             }
         }
    }
    
    func verifyOTP(mobile:String,otp:String){
        
        guard let urlstr = APIURL.verifyOTP.url?.absoluteString else { return }
//        let getUrl = urlstr + "\(mobileNumber)"
        
        let url = URL(string: urlstr)
        
        guard let url = url else{
            self.onError?("Invalid URL")
            return
        }
        
        let params: [String: Any] = [
              "mobile": mobile,
              "code": otp
        ]
        
        APIManager.shared.postRequest(urlString: url , body: params, responseType: VerifyOTPModel.self) { result in
             DispatchQueue.main.async{
                 switch result {
                 case .success(let response):
                     self.onVerifyOTPSucess?(response)
                 case .failure(let failure):
                     self.onError?(failure.localizedDescription)
                 }
             }
         }
    }
    
    func SubmitUserRegistrationInfo(name: String, mobile: String, address: String = "", gender: String, email: String, country: String, dob: String) {

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
    
    
    
    func SubmitBookingInfo(userId: String, hotelId: String, roomId: String, guestName: String, guestPhone: String, guestEmail: String, numberOfGuests: Int,checkIn : String, checkOut : String,  totalAmount : Double, bookingDetails: String ) {

        let params: [String: Any] = [
       
          "userId": userId,
          "hotelId": hotelId,
          "roomId": roomId,
          "guestName": guestName,
          "guestPhone": guestPhone,
          "guestEmail": guestEmail,
          "numberOfGuests": numberOfGuests,
          "checkIn": checkIn,
          "checkOut": checkOut,
          "totalAmount": totalAmount,
          "bookingDetails": bookingDetails
        ]
        
        guard let url =  APIURL.postBooking.url else {
            self.onError?("Invalid URL")
            return
        }
        
       APIManager.shared.postRequest(urlString: url , body: params, responseType: PostBookingResponse.self) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
                    self.onPostBookingSuccess?(response)
                case .failure(let failure):
                    self.onError?(failure.localizedDescription)
                }
            }
        }
    }
    
}
