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
    //    var onError: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    var onVerifyOTPSucess : ((VerifyOTPModel) -> Void)?
    var onEmailVerifyOTPSuccess : ((VerifyEmailOTPModel) -> Void)?
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func fetchUserByMobile(_ mobile: String) async throws -> BookingResponse {
        try await apiClient.send(
            endpoint: .fetchUserByMobile(mobile),
            responseType: BookingResponse.self
        )
    }
    
    func fetchUserById(_ id: String) async throws -> BookingResponse {
        try await apiClient.send(
            endpoint: .fetchUserById(id),
            responseType: BookingResponse.self
        )
    }
    
    func fetchCurrentUser() async throws -> BookingResponse {
        try await apiClient.send(
            endpoint: .fetchCurrentUser,
            responseType: BookingResponse.self
        )
    }
    
    
    func FetchUserData(mobile:String? = nil,id:String? = nil){
        
        let urlstr = APIURL.bookingURL.url.absoluteString
        var getUrl = ""
        if let mobile = mobile, !mobile.isEmpty {
            getUrl = urlstr + "/mobile/\(mobile)"
        } else if let id = id, !id.isEmpty{
            getUrl = urlstr + "/\(id)"
        }else{
            self.onError?(NetworkError.EnterValidData)
        }
        
        let url = URL(string: getUrl)
        
        guard let url = url else{
            self.onError?(NetworkError.invalidURL)
            return
        }
        
        APIManager.shared.fetchData(from: url, requiresJWT: true, modelType: BookingResponse.self) { result  in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.onSuccess?(success.data)
                    
                case .failure(let failure):
                    
                    // ✅ Debug log (safe for dev only)
#if DEBUG
                    print("❌ FetchuserData Function Error:", failure)
#endif
                    // ✅ Always pass real error
                    self.onError?(failure)
                }
            }
        }
    }
    
    var onOTPSuccess: ((OTPResponseModel) -> Void)?
    
    func fetchOTP(mobileNumber:String){
        
        let urlstr = APIURL.postForOTP.url.absoluteString
        //        let getUrl = urlstr + "\(mobileNumber)"
        
        let url = URL(string: urlstr)
        
        guard let url = url else{
            self.onError?(NetworkError.invalidURL)
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
#if DEBUG
                    print(failure.localizedDescription)
#endif
                    
                    self.onError?(failure)
                }
            }
        }
    }
    
    func verifyOTP(mobile:String,otp:String){
        
        let urlstr = APIURL.verifyOTP.url.absoluteString
        let url = URL(string: urlstr)
        
        guard let url = url else{
            self.onError?(NetworkError.invalidURL)
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
#if DEBUG
                    print("Error Verify OTP : \(failure.localizedDescription)")
#endif
                    self.onError?(failure)
                }
            }
        }
    }
    
    func fetchEmailOTP(email:String){
        
        //            let urlstr = APIURL.postForNewUserOTP.url.absoluteString
        
        let urlstr = APIURL.postForNewUserOTP.url.absoluteString
        
        let url = URL(string: urlstr)
        
        guard let url = url else{
            self.onError?(NetworkError.invalidURL)
            return
        }
        
        let params: [String: Any] = [
            "email": email
        ]
        
        APIManager.shared.postRequest(urlString: url , body: params, responseType: OTPResponseModel.self) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
                    self.onOTPSuccess?(response)
                case .failure(let failure):
#if DEBUG
                    print("Error Fetch Email OTP : \(failure.localizedDescription)")
#endif
                    self.onError?(failure)
                }
            }
        }
    }
    
    func verifyEmailOTP(email:String,otp:String){
        
        let urlstr = APIURL.verifyNewUserOTP.url.absoluteString
        let url = URL(string: urlstr)
        
        guard let url = url else{
            self.onError?(NetworkError.invalidURL)
            return
        }
        
        let params: [String: Any] = [
            "email": email,
            "code": otp
        ]
        
        APIManager.shared.postRequest(urlString: url , body: params, responseType: VerifyEmailOTPModel.self) { result in
            DispatchQueue.main.async{
                switch result {
                case .success(let response):
                    self.onEmailVerifyOTPSuccess?(response)
                case .failure(let failure):
#if DEBUG
                    print("Error Verify Email OTP : \(failure.localizedDescription)")
#endif
                    self.onError?(failure)
                }
            }
        }
    }
    
    func getDummyDOB() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = formatter.date(from: "1900-01-01") {
            return iso8601String(from: date) // 👉 "1900-01-01T00:00:00.000Z"
        }
        return "1900-01-01T00:00:00.000Z" // fallback hardcoded
    }
    
    func iso8601String(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
    
    
    func SubmitUserRegistrationInfo(name: String,mobile: String,address: String = "",gender: String,email: String,country: String,dob: String) {
        
        let finalDob = (dob.isEmpty) ? getDummyDOB() : dob
        let params: [String: Any] = [
            "name": name,
            "mobile": mobile,
            "address": address,
            "gender": gender,
            "email": email,
            "country": country,
            "dob": finalDob
        ]
        
        let url = APIURL.bookingURL.url
        
        APIManager.shared.postRequest(urlString: url,body: params,responseType: BookingResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.onSuccess?(response.data)
                case .failure(let failure):
#if DEBUG
                    print("submit user registration info function error : \(failure.localizedDescription)")
#endif
                    self.onError?(failure)
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
#if DEBUG
                print("loadCountries function: \(error.localizedDescription)")
#endif
                
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
    
    func postBookingDetails(_ PostBookingRequest: PostBookingRequestEncodable) async throws -> PostBookingWrapper {
        
        let data = PostBookingRequest
        
        let request = PostBookingRequestEncodable(userId: data.userId, hotelId: data.hotelId, roomId: data.roomId, guestName: data.guestName, guestPhone: data.guestPhone, guestEmail: data.guestEmail, numberOfGuests: data.numberOfGuests, checkIn: data.checkIn, checkOut: data.checkOut, totalAmount: data.totalAmount, bookingDetails: data.bookingDetails, bookingType: data.bookingType, totalDiscount: data.totalDiscount, netTotal: data.netTotal)
        
        return try await apiClient.send(
            endpoint: .postBookingData,
            body: request,
            responseType: PostBookingWrapper.self)
    }
    
//    func SubmitBookingInfo(userId: String,hotelId: String,roomId: String,guestName: String,guestPhone: String,guestEmail: String,numberOfGuests: Int,checkIn: String,checkOut: String, totalAmount: Double,bookingDetails: String, bookingType: String, totalDiscount: Double, netTotal: Double
//    ) {
//        let params: [String: Any] = [
//            "userId": userId,
//            "hotelId": hotelId,
//            "roomId": roomId,
//            "guestName": guestName,
//            "guestPhone": guestPhone,
//            "guestEmail": guestEmail,
//            "numberOfGuests": numberOfGuests,
//            "checkIn": checkIn,
//            "checkOut": checkOut,
//            "totalAmount": totalAmount,
//            "bookingDetails": bookingDetails,
//            "bookingType": bookingType,
//            "totalDiscount": totalDiscount,
//            "netTotal": netTotal
//        ]
//        
//        print("📤 Request body:", params)
//        
//        let url = APIURL.postBooking.url
//        
//        APIManager.shared.postRequest(urlString: url, body: params, responseType: PostBookingWrapper.self) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let wrapper):
//                    if let booking = wrapper.data {
//                        print("✅ Parsed Booking:", booking)
//                        self.onPostBookingSuccess?(booking)
//                    } else {
//                        print("⚠️ Wrapper received but no booking data")
//                    }
//                case .failure(let error):
//#if DEBUG
//                    print("❌ Decoding error:", error.localizedDescription)
//#endif
//                    self.onError?(NetworkError.decodingFailed)
//                }
//            }
//        }
//    }
    
    func getBookingHistory(userId:String,BookingId:String, requiresJWT: Bool = false, completion: @escaping (BookingHistoryDataModel) -> Void){
        let urlstr = APIURL.postBooking.url.absoluteString
        var getUrl = ""
        getUrl = urlstr + "/me/\(BookingId)"
        
        let url = URL(string: getUrl)
        guard let url = url else{
            self.onError?(NetworkError.invalidURL)
            return
        }
        
        APIManager.shared.fetchData(from: url, requiresJWT: true, modelType: BookingHistoryDetailsResponseModel.self) { result  in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    completion(success.data)
                    print(success)
                    
                case .failure(let failure):
#if DEBUG
                    print(" Error getBookingHistory function: \(failure.localizedDescription)")
#endif
                    self.onError?(failure)
                    
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
        let baseURL = APIURL.postBooking.url
        
        // Build URL safely
        let url = baseURL
            .appendingPathComponent("me")
            .appendingPathComponent(bookingId)
            .appendingPathComponent("cancel")
        
        let params: [String: Any] = ["reason": reason]
        
        APIManager.shared.postRequest(
            urlString: url,
            body: params,
            responseType: BookingHistoryDetailsResponseModel.self,
            requiresJWT: true
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
#if DEBUG
                    print("Error in Cancel: \(error.localizedDescription)")
#endif
                    self.onError?(error)
                    completion(nil)
                }
            }
        }
    }
    
}

extension Endpoint {
    static func fetchUserById(_ id: String) -> Endpoint{
        Endpoint(
            path: APIURL.bookingURL.url.appendingPathComponent(id),
            method: .get,
            authentication: .jwt
        )
    }
    
    static func fetchUserByMobile(_ mobile: String) -> Endpoint{
        Endpoint(
            path: APIURL.bookingURL.url.appendingPathComponent("mobile").appendingPathComponent(mobile),
            method: .get,
            authentication: .jwt
        )
    }
    
    static let fetchCurrentUser = Endpoint(
        path: APIURL.bookingURL.url.appendingPathComponent("me"),
        method: .get,
        authentication: .jwt
    )
}


extension Endpoint {
    static let postBookingData =
        Endpoint(
            path: APIURL.postBooking.url,
            method: .post,
            authentication: .jwt
        )
    }
    



