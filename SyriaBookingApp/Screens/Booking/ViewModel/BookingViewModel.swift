//
//  BookingViewModel.swift
//  SyriaBookingApp
//
//  Created by ToqSoft on 22/08/25.
//

import Foundation

class BookingViewModel {
    
    var onSuccess: ((BookingModel) -> Void)?
    var onPostBookingSuccess : ((PostBookingResponse) -> Void)?
    var onHistorySuccess : ((BookingHistoryDataModel) -> Void)?
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
    
    func SubmitUserRegistrationInfo(name: String,mobile: String,address: String = "",gender: String,email: String,country: String,dob: String) {
        let params: [String: Any] = [
            "name": name,
            "mobile": mobile,
            "address": address,
            "gender": gender,
            "email": email,
            "country": country,
            "dob": dob
        ]
        
        guard let url = APIURL.BookingURL.url else {
            self.onError?("Invalid URL")
            return
        }
        
        APIManager.shared.postRequest(urlString: url,body: params,responseType: BookingResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.onSuccess?(response.data)
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
    func postRequest<T: Decodable>(urlString: URL,body: [String: Any],responseType: T.Type,completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            // 📩 Log the raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📩 Full JSON Response: \(jsonString)")
            }
            
            do {
                let decoded = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func SubmitBookingInfo(userId: String,hotelId: String,roomId: String,guestName: String,guestPhone: String,guestEmail: String,numberOfGuests: Int,checkIn: String,checkOut: String,totalAmount: Double,bookingDetails: String
    ) {
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
        
        print("📤 Request body:", params)
        
        guard let url = APIURL.postBooking.url else {
            self.onError?("Invalid URL")
            return
        }
        
        APIManager.shared.postRequest(urlString: url, body: params, responseType: PostBookingWrapper.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let wrapper):
                    if let booking = wrapper.data {
                        print("✅ Parsed Booking:", booking)
                        self.onPostBookingSuccess?(booking)
                    } else {
                        print("⚠️ Wrapper received but no booking data")
                    }
                case .failure(let error):
                    print("❌ Decoding error:", error.localizedDescription)
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func getBookingHistory(userId:String,BookingId:String, completion: @escaping (BookingHistoryDataModel) -> Void){
        guard let urlstr = APIURL.postBooking.url?.absoluteString else { return }
        var getUrl = ""
        getUrl = urlstr + "\(userId)/\(BookingId)"
        
        let url = URL(string: getUrl)
        guard let url = url else{
            self.onError?("Invalid URL")
            return
        }
        
        APIManager.shared.fetchData(from: url, modelType: BookingHistoryDetailsResponseModel.self) { result  in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    completion(success.data)
                    print(success)
                    
                case .failure(let failure):
                    self.onError?(failure.localizedDescription)
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    func postCancelBooking(
        reason: String,
        userId: String,
        bookingId: String,
        completion: @escaping (BookingHistoryDetailsResponseModel?) -> Void
    ) {
        guard let baseURL = APIURL.postBooking.url else {
            self.onError?("Invalid Base URL")
            completion(nil)
            return
        }
        
        // Build URL safely
        let url = baseURL
            .appendingPathComponent(userId)
            .appendingPathComponent(bookingId)
            .appendingPathComponent("cancel")
        
        let params: [String: Any] = ["reason": reason]
        
        APIManager.shared.postRequest(
            urlString: url,
            body: params,
            responseType: BookingHistoryDetailsResponseModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    print("Error in Cancel: \(error.localizedDescription)")
                    self.onError?(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }

}
