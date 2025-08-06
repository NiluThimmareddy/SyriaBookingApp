////
////  UserFeedBackListVC.swift
////  HotelBooking
////
////  Created by praveenkumar on 18/06/25.
////
//
//import UIKit
//
//class UserFeedBackListVC: UIViewController {
//
//    @IBOutlet weak var feedBackListTV: UITableView!
//    
//    let color = UIColor(named: "defaultColor")
//    var callHotelFeedBack = [
//        HotelFeedBackInfo(hotelImage: "1", hotelName: "Taj", bookedDate: "15 - 16 May 2025", hotelLocation: "Chennai", status: "Completed", process: "Done",rating: "3", hotelId: "546083d0-28f4-479b-b845-7d32f3d56a96"),
//        HotelFeedBackInfo(hotelImage: "2",hotelName: "Chola", bookedDate: "15 - 16 June 2025",hotelLocation: "Chennai",status: "Pending",process: "Draft",rating: "", hotelId: "d89b276b-7436-4a95-b8c7-de51abb9d634")
//    ]
//    let viewModel = HotelJsonViewModel()
//    let topNameLbl: UILabel = {
//       let label = UILabel()
//       label.textColor = .white
//       label.text = "Your Reviews"
//       label.font = UIFont.poppinsBold(16)
//       label.textAlignment = .center
//       return label
//   }()
//   
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let appearance = UIBarButtonItem.appearance()
//        appearance.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
//        feedBackListTV.register(UINib(nibName: "UserFeedBackListTVC", bundle: nil), forCellReuseIdentifier: "UserFeedBackListTVC")
//        feedBackListTV.showsVerticalScrollIndicator = false
//        feedBackListTV.showsHorizontalScrollIndicator = false
//        navigationItem.titleView = topNameLbl
//        callPoliciesData()
//    }
//    
//    func callPoliciesData(){
//        viewModel.switchDisplayMode(to: .hotel)
//        viewModel.fetchHotels {
//            DispatchQueue.main.async {
//                print("✅ Hotel data fetched:")
//                for hotel in self.viewModel.allHotels {
//                    print("Hotel ID: \(hotel.HotelId), Name: \(hotel.HotelName)")
//                            }
//                self.feedBackListTV.reloadData()
//               
//            }
//        }
//    }
//   
//    
//}
//
//extension UserFeedBackListVC: UITableViewDelegate, UITableViewDataSource, UserFeedBackListTVCDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return callHotelFeedBack.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFeedBackListTVC")as! UserFeedBackListTVC
//        let data = callHotelFeedBack[indexPath.row]
//        cell.bookedDate.text = data.bookedDate
//        cell.hotelName.text = data.hotelName
//        cell.hotelImage.image = UIImage(named: data.hotelImage)
//        cell.hotelLocation.text = data.hotelLocation
//        cell.delegate =  self
//        if data.status == "Pending"{
//            cell.starBackView.isHidden = true
//            cell.howManyDaysLeftToGiveReview.text = data.daysRemaining
//            cell.completeButton.isHidden = false
//            let selectRoom = NSAttributedString(
//                string: "Complete your draft review",
//                attributes: [.font: UIFont.poppinsBold(12), .foregroundColor: color ?? UIColor.white ]
//            )
//            cell.completeButton.setAttributedTitle(selectRoom, for: .normal)
//            
//        }else{
//            cell.starBackView.isHidden = false
//            cell.completeButton.isHidden = true
//            cell.howManyDaysLeftToGiveReview.text = "Thanks for your useful Feedback"
//            cell.setRatingStars(from: data.rating)
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 180
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = callHotelFeedBack[indexPath.row]
//        
//        let filterData = viewModel.allHotels.filter { $0.HotelId == data.hotelId }
//        
//        guard let finalData = filterData.first else {
//            print("No matching hotel found")
//            return
//        }
//        
//        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
//        controller.hotelDetailsData = finalData
//        controller.modalPresentationStyle = .fullScreen
//        navigationItem.backButtonTitle = ""
//        self.navigationController?.pushViewController(controller, animated: true)
//        
//    }
//    
//    func didCompleteFeedback() {
//        let controller = UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "PostReviewViewController") as! PostReviewViewController
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        self.navigationItem.backBarButtonItem = backItem
//        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//    
//    
//    
//}
