
import UIKit

class AboutUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "About Us"
        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])


        stackView.addArrangedSubview(createTitle("Welcome to SyriaBooking"))
        stackView.addArrangedSubview(createSubtitle("Hotel Booking System"))
        stackView.addArrangedSubview(createBody("""
Your Trusted Partner for Hotel Bookings Across Syria

At SyriaBooking.sy, we are redefining travel and hospitality within Syria by offering a convenient, transparent, and secure hotel booking experience for both local and international travelers. Founded with a vision to support Syria’s growing tourism and business sectors, our platform connects travelers with a wide range of hotels, guesthouses, and resorts — from affordable stays to luxury experiences — all across the country.
"""))
        
        stackView.addArrangedSubview(createSubtitle("What We Offer"))
        
        stackView.addArrangedSubview(createHeading("1. Wide Selection of Properties"))
        stackView.addArrangedSubview(createBody("""
Whether you're visiting Damascus, Aleppo, Latakia, Tartus, Homs, or any other Syrian city, we’ve partnered with trusted hotels to give you comfortable, verified options.
"""))
        
        stackView.addArrangedSubview(createHeading("2. Book Now, Pay on Arrival"))
        stackView.addArrangedSubview(createBody("""
No need for credit cards or upfront payments. Simply search, choose, and book your stay — and pay directly at the hotel when you arrive.
"""))
        
        stackView.addArrangedSubview(createHeading("3. Easy Booking Process"))
        stackView.addArrangedSubview(createBody("""
Designed for simplicity. Search hotels by city, dates, or budget, and complete your reservation in just a few clicks.
"""))
        
        stackView.addArrangedSubview(createHeading("4. Real Information, No Surprises"))
        stackView.addArrangedSubview(createBody("""
We provide detailed hotel descriptions, real photos, amenities, guest reviews, and location maps — so you always know what to expect.
"""))
        
        stackView.addArrangedSubview(createHeading("5. Local Expertise"))
        stackView.addArrangedSubview(createBody("""
We are a Syrian-based platform that understands the local market, the culture, and your travel needs. Our team is here to guide and support you every step of the way.
"""))
    }
    
    private func createTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }
    
    private func createSubtitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
        return label
    }
    
    private func createHeading(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }
    
    private func createBody(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        return label
    }
}
