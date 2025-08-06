//
//  PrivacyPolicyVC.swift
//  HotelBooking
//
//  Created by praveenkumar on 01/07/25.
//

import UIKit
import WebKit



class PrivacyPolicyVC: UIViewController {
    
    @IBOutlet weak var webViewData: WKWebView!
    
    var contentType: StaticContentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSelectedHTML()
    }
    
    
    private func loadSelectedHTML() {
        switch contentType {
        case .privacy:
            self.title = "Privacy Policy"
            loadPrivacyPolicyHTML()
        case .terms:
            self.title = "Terms of Use"
            loadTermOfUseHTML()
        case .about:
            self.title = "About Us"
            loadAboutUsHTML()
        default:
            self.title = "Info"
        }
    }
    
    private func base64StringFromAsset(named imageName: String) -> String? {
            guard let image = UIImage(named: imageName),
                  let imageData = image.jpegData(compressionQuality: 1.0) else {
                return nil
            }
            return imageData.base64EncodedString()
        }
    
    private func loadTermOfUseHTML() {
        let htmlString = """
                 <!DOCTYPE html>
                    <html>
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <style>
                            body {
                                font-family: Arial, sans-serif;
                                line-height: 1.6;
                                color: #333;
                                padding: 5px;
                                max-width: 100%;
                                word-wrap: break-word;
                                background-color: transparent;
                            }
                            h1 {
                                font-size: 1.5em;
                                color: #2c3e50;
                                margin-bottom: 16px;
                            }
                            h2 {
                                font-size: 1.3em;
                                color: #2c3e50;
                                margin-top: 24px;
                                margin-bottom: 12px;
                            }
                            h3 {
                                font-size: 1.1em;
                                color: #2c3e50;
                                margin-top: 18px;
                                margin-bottom: 8px;
                            }
                            p {
                                margin-bottom: 12px;
                            }
                            a {
                                color: #3498db;
                                text-decoration: none;
                            }
                            .section {
                                margin-bottom: 24px;
                            }
                            .subsection {
                                margin-bottom: 16px;
                            }
                            .last-updated {
                                font-size: 0.9em;
                                color: #7f8c8d;
                                margin-top: 24px;
                                text-align: right;
                            }
                        </style>
                    </head>
                    <body>
                        <h1>General Terms of Use</h1>
                        <div class="section">
                            <h2>1. Your Agreement</h2>
                            <p>1.1 This website www.hotelbooking.com and/or the HotelBooking App (together, 'HotelBooking Platform') is operated by HotelBooking Travel Technology Limited, a Hong Kong incorporated company. Please read these terms of use ("this Terms of Use") carefully before using the HotelBooking Platform and the services offered by HotelBooking Travel Technology Limited, its affiliated companies (together, "HotelBooking") or the third-party operators (the "Operator") through the HotelBooking Platform (the "Services"). "You" and "your" when used in this Terms of Use includes (1) any person who accesses the HotelBooking Platform and (2) persons for whom you make a purchase of the Services.</p>
                        </div>
                        
                        <div class="section">
                            <h2>2. Change of Terms of Use</h2>
                            <h3>2.1 HotelBooking's Modifications</h3>
                            <p>2.1.1 HotelBooking reserves the right, at its sole discretion, to change or modify any part of this Terms of Use at any time without prior notice. You should visit this page periodically to review the current Terms of Use to which you are bound. If HotelBooking changes or modifies this Terms of Use, HotelBooking will post the changes to or modifications of this Terms of Use on this page and will indicate at the bottom of this page the date on which this Terms of Use was last revised.</p>
                            <p>2.1.2 Your continued use of the HotelBooking Platform after any such changes or modifications constitutes your acceptance of the revised Terms of Use. If you do not agree to abide by the revised Terms of Use, do not use or access or continue to use or access the HotelBooking Platform and/or the Services. It is your responsibility to regularly check the HotelBooking Platform to ascertain if there are any changes to this Terms of Use and to review such changes.</p>
                            <p>2.1.3 In addition, when using the Services, you shall be subject to any additional terms applicable to such Services that may be posted on the page relating to such Services from time to time, the privacy policy (the "Privacy Policy") and the terms and conditions of HotelBooking AI tools (the "Terms and Conditions of HotelBooking AI Tools") adopted by HotelBooking from time to time. All such terms are hereby expressly incorporated by reference in this Terms of Use.</p>
                        </div>
                        
                        <div class="section">
                            <h2>3. Access and Use of the Services</h2>
                            <h3>3.1 Ownership of Content</h3>
                            <p>3.1.1 This HotelBooking Platform, the domain name (www.hotelbooking.com), subdomains, features, contents and application services (including without limitation to any mobile application services) offered periodically by HotelBooking in connection therewith are owned and operated by HotelBooking.</p>
                            
                            <h3>3.2 Provision and Accessibility of Services</h3>
                            <p>3.2.1 Subject to this Terms of Use, HotelBooking may either offer to provide the Services by itself or on behalf of the Operators, as described in further detail on the HotelBooking Platform. The Services that have been selected by you on the HotelBooking Platform are solely for your own use, and not for the use or benefit of any third party. The term "Services" includes but is not limited to the use of the HotelBooking Platform, any Services offered by HotelBooking by itself or on behalf of the Operators on the HotelBooking Platform. HotelBooking may change, suspend or discontinue any Services at any time, including the availability of any feature, database or content. HotelBooking may also impose limits or conditions on certain Services or restrict your access to any part or all of the Services without notice or liability.</p>
                            <p>3.2.2 HotelBooking does not guarantee that the Services will always be available or uninterrupted. HotelBooking will not be liable to you if for any reason the Services are unavailable at any time or for any period. You are responsible for making all arrangements necessary for you to have access to the Services. You are also responsible for ensuring that all persons who access the Services through Internet connection are aware of this Terms of Use and other applicable terms and conditions for the Services, and that they comply with them.</p>
                            <p>3.2.3 If you link to the HotelBooking Platform, HotelBooking may revoke your rights to so link at any time, at HotelBooking's sole discretion. HotelBooking reserves the right to require prior written consent before linking to the HotelBooking Platform.</p>
                        </div>
                        
                        
                        <div class="section">
                            <h2>4. HotelBooking Platform and Content</h2>
                            
                                <h3>4.1 Use of the Content</h3>
                                <p>4.1.1 All materials displayed or performed on the HotelBooking Platform including but not limited to text, data, graphics, articles, photographs, images, illustrations, video, audio and other materials ("Content") are protected by copyright and/or other intellectual property rights. This HotelBooking Platform and the Content are intended solely for your personal and non-commercial use of the Services and may only be used in accordance with Terms of Use. For the avoidance of doubt, any inputs into and outputs from HotelBooking AI Tools do not constitute "Content". For more information on HotelBooking AI Tools, please see the Terms and Conditions of HotelBooking AI Tools.</p>
                                
                                <p>4.1.2 If HotelBooking agrees to grant you access to the HotelBooking Platform and/or the Content, such access shall be non-exclusive, non-transferable and limited license to access the HotelBooking Platform in accordance with this Terms and Use. HotelBooking may, at its absolute discretion and at any time, without prior notice to you, amend or remove or alter the presentation, substance or functionality of any part or all of the Content from the HotelBooking Platform.</p>
                                
                                <p>4.1.3 You shall abide by all copyright notices, trademark rules, information, and restrictions contained in the HotelBooking Platform and the Content accessed through the HotelBooking Platform, and shall not use, copy, reproduce, modify, translate, publish, broadcast, transmit, distribute, perform, upload, display, license, sell or otherwise exploit for any purposes whatsoever the HotelBooking Platform or the Content or third party submissions or other proprietary rights not owned by you without the express prior written consent of the respective owners, or in any way that violates any third party rights.</p>
                          
                                <h3>4.2 HotelBooking's Liability for the HotelBooking Platform and Content</h3>
                                <p>4.2.1 HotelBooking cannot guarantee the identity of any other users with whom you may interact with in the course of using the HotelBooking Platform. HotelBooking cannot guarantee the authenticity and accuracy of any content, materials or information which other users or the Operators may provide. All Content accessed by you using the HotelBooking Platform is at your own risk and you will be solely responsible for any damage or loss to any party resulting therefrom.</p>
                                
                                <p>4.2.2 Under no circumstances will HotelBooking be liable in any way for any Content, including but not limited to any errors or omissions in any Content, or any loss or damage of any kind incurred in connection with the use of or exposure to any Content posted, emailed, accessed, transmitted, or otherwise made available via the HotelBooking Platform.</p>
                                
                                <p>4.2.3 Sort Order: We provide sorting and filter settings for you to adapt the search results to your preferences using criteria such as availability, price recommendations, Services' popularity, Services' reviews or other criteria. We continually optimize the HotelBooking Platform to provide you the best experience and may test different default sort order algorithms from time to time.</p>
                        </div>
                        
                        <div class="section">
                            <h2>5. Intellectual Property Rights</h2>
                            
                                <h3>5.1 Intellectual Property</h3>
                                <p>5.1.1 All intellectual property rights subsisting in respect of the HotelBooking Platform belong to HotelBooking or have been licensed to HotelBooking for use on the HotelBooking Platform. This HotelBooking Platform, the Services and the Content are protected by copyright and other intellectual property rights as collective works and/or compilations, pursuant to applicable copyright laws, international conventions, and other intellectual property laws. You undertake that:</p>
                                
                                    <p>(a) You shall not modify, publish, transmit, participate in the transfer or sale of, reproduce, create derivative works based on, distribute, perform, display, or in any way exploit, any part of the HotelBooking Platform and the Content, software, materials, or the Services in whole or in part;</p>
                                    
                                    <p>(b) You shall only download or copy the Content (and other items displayed on the HotelBooking Platform or related to the Services) for personal and non-commercial use only, provided that you maintain all copyright and other notices contained in such Content; and</p>
                                    
                                    <p>(c) You shall not store any significant portion of any Content in any form. Copying or storing of any Content other than personal and non-commercial use is expressly prohibited without prior written permission from HotelBooking or from the copyright holder identified in such Contents copyright notice.</p>
                        </div>

                        <div class="section">
                            <h2>6. User Submissions</h2>
                            
                            <h3>6.1 Uploading of Information</h3>
                            <p>6.1.1 In the course of accessing the HotelBooking Platform or using the Services, you may provide information which may be used by HotelBooking and/or the Operators in connection with the Services and which may be visible to other users of the HotelBooking Platform. You understand that by posting information or content on the HotelBooking Platform or otherwise providing content, materials or information to HotelBooking and/or the Operators in connection with the Services ("User Submissions"):</p>
                            
                            <p>(a) You hereby grant to HotelBooking and the Operators a non-exclusive, worldwide, royalty free, perpetual, irrevocable, sub-licensable and transferable right to use and fully exploit such User Submissions, including all related intellectual property rights subsisted thereon, in connection with providing the Services and operating the HotelBooking Platform and HotelBooking's business, including but not limited to the promotion and redistribution of part or all of the Services and derivative works thereof in any media formats and through any media channels;</p>
                            
                            <p>(b) You agree and authorize HotelBooking to use your personal data in accordance with the Privacy Policy in effect from time to time;</p>
                            
                            <p>(c) You hereby grant each user of the HotelBooking Platform a non-exclusive license to access your User Submissions through the HotelBooking Platform, and to use, modify, reproduce, distribute, prepare derivative works of, display and perform such User Submissions as permitted through the functionality of the HotelBooking Platform and under this Terms of Use;</p>
                            
                            <p>(d) You acknowledge and agree that HotelBooking retains the right to reformat, modify, create derivative works of, excerpt, and translate any User Submissions submitted by you. For clarity, the foregoing license grant to HotelBooking does not affect your ownership of or right to grant additional non-exclusive licenses to the material in the User Submissions, unless otherwise agreed in writing;</p>
                            
                            <p>(e) You hereby represent and warrant that any content in your User Submission (including but not limited to text, graphics and photographs) do not infringe any applicable laws, regulations or any third party rights; and</p>
                            
                            <p>(f) That all the User Submissions publicly posted or privately transmitted through the HotelBooking Platform is the sole responsibility of you and that HotelBooking will not be liable for any errors or omissions in any content.</p>
                    </div>
                    
                    
                    <div class="section">
                        <h2>7. Users Representations, Warranties and Undertakings</h2>
                        
                        <h3>7.1 Use of the HotelBooking Platform and the Services</h3>
                        <p>7.1.1 You represent, warrant and undertake to HotelBooking that you will not provide any User Submissions or otherwise use the HotelBooking Platform or the Services in a manner that: (a) Infringes or violates the intellectual property rights or proprietary rights, rights of publicity or privacy, or other rights of any third party; or (b) Violates any law, statute, ordinance or regulation; or (c) Is harmful, fraudulent, deceptive, threatening, abusive, harassing, tortious, defamatory, vulgar, obscene, libelous, or otherwise objectionable; or (d) Involves commercial activities and/or sales without HotelBooking's prior written consent such as contests, sweepstakes, barter, advertising, or pyramid schemes; or (e) Constitutes libel, impersonates any person or entity, including but not limited to any employee or representative of HotelBooking; or (f) Contains a virus, trojan horse, worm, time bomb, or other harmful computer code, file, or program.</p>
                        
                        <h3>7.2 Removal of User Submissions</h3>
                        <p>7.2.1 HotelBooking reserves the right to remove any User Submissions from this HotelBooking Platform at any time, for any reason including but not limited to, receipt of claims or allegations from third parties or authorities relating to such User Submission or if HotelBooking is concerned that you may have breached any of the preceding representations, warranties or undertakings, or for no reason at all.</p>
                        
                        <h3>7.3 Responsibility for User Submissions</h3>
                        <p>7.3.1 You remain solely responsible for all User Submissions that you upload, post, email, transmit, or otherwise disseminate using, or in connection with, the HotelBooking Platform.</p>
                        <p>7.3.2 You acknowledge and agree that you shall be solely responsible for your own User Submissions and the consequences of posting or publishing all of your User Submissions on the HotelBooking Platform. You represent, warrant and undertake to HotelBooking that: (a) You own or have the necessary rights, licenses, consents, releases and/or permissions to use and authorize HotelBooking to use all copyright, trademark or other proprietary or intellectual property rights in and to any User Submission to enable inclusion and use thereof as contemplated by the HotelBooking Platform and this Terms of Use; and (b) Neither the User Submissions nor your posting, uploading, publication, submission or transmittal of the User Submission or HotelBooking's use of the User Submissions, or any portion thereof, on or through the HotelBooking Platform and/or the Services will infringe, misappropriate or violate any third party's patent, copyright, trademark, trade secret, moral rights or other proprietary or intellectual property rights, or rights of publicity or privacy, or result in the violation of any applicable law, rule or regulation.</p>
                        <p>7.3.3 You are responsible for all of your activity in connection with using the HotelBooking Platform and/or the Services. You further represent, warrant and undertake to HotelBooking that you shall not: (a) Conduct any fraudulent, abusive, or otherwise illegal activity which may be grounds for termination of your right to access or use the HotelBooking Platform and/or the Services; or (b) sell or resell any products, services or reservation obtained from or via the HotelBooking Platform; (c) use the HotelBooking Platform for commercial or competitive activity or purposes, or for the purpose of making speculative, false or fraudulent bookings or any reservations in anticipation of demand; (d) Post or transmit, or cause to be posted or transmitted, any communication or solicitation designed or intended to obtain password, account, or private information from any other user of the HotelBooking Platform; or (e) Violate the security of any computer network, crack passwords or security encryption codes, transfer or store illegal material (including material that may be considered threatening or obscene), or engage in any kind of illegal activity that is expressly prohibited; or (f) Run maillist, listserv, or any other form of auto-responder, or "spam" on the HotelBooking Platform, or any processes that run or are activated while you are not logged on to the HotelBooking Platform, or that otherwise interfere with the proper working of or place an unreasonable load on the HotelBooking Platform's infrastructure; or (g) Use manual or automated software, devices, or other processes to "crawl," "scrape," or "spider" any page of the HotelBooking Platform; or (h) Decompile, reverse engineer, or otherwise attempt to obtain the source code of HotelBooking Platform.</p>
                        <p>7.3.4 You will be responsible for withholding, filing, and reporting all taxes, duties and other governmental assessments associated with your activity in connection with using the HotelBooking Platform and/or the Services.</p>
                     </div>
                     <div class="section">    
                        <h2>8. Registration and Security</h2>
                        
                        <h3>8.1 Opening of the HotelBooking Account</h3>
                        <p>8.1.1 In the course of using the Services, you may be required to open and maintain an account with HotelBooking ("HotelBooking Account").</p>
                        
                        <h3>8.2 Provision of Personal Information</h3>
                        <p>8.2.1 As a condition to using some aspects of the Services, you may be required to register with HotelBooking and select a password and user name ("HotelBooking User ID"). If you are accessing the Services through a Third Party Website or service, HotelBooking may require that your HotelBooking User ID be the same as your user name for such Third Party Website or service.</p>
                        <p>8.2.2 You shall provide HotelBooking with accurate, complete, and updated registration information. Failure to do so shall constitute a breach of this Terms of Use, which may result in immediate termination of your HotelBooking Account.</p>
                        <p>8.2.3 You represent that you shall not: (a) Select or use as a HotelBooking User ID a name of another person with the intent to impersonate that person; or (b) Use as a HotelBooking User ID a name subject to any rights of a person other than you without appropriate authorization.</p>
                        <p>8.2.4 HotelBooking reserves the right to refuse registration of or to cancel a HotelBooking Account at its sole discretion. You shall be responsible for maintaining the confidentiality of your password.</p>
                      </div> 
                        <div class="section">
                        <h2>9. Reviews - Further correspondence - Rights to User Content</h2>
                        
                        <p>9.1. By completing a booking, you agree to receive confirmation messages (in the form of emails and/or app notifications), as well as an invitation email(s) or app notification(s) for you to complete our guest review form which we will send to you after you finish an activity. Leaving a review is optional. For clarity, the confirmation and guest review emails are transactional and are not part of the newsletters or marketing mails, from which you can unsubscribe. The completed guest review may be uploaded onto the relevant activity page on the HotelBooking platform within 72 hours of the submission for the sole purpose of informing (future) customers of your opinion of the service (level) and quality of the Activity. Upon submitting a review, your account may be awarded HotelBookingCash, which may be used towards your next booking subject to terms and conditions. Each account may only submit one review per activity booked once or multiple times within the same calendar month. Fraud and abuse will result in the forfeiture of HotelBookingCash. HotelBooking further reserves the right to deduct any HotelBookingCash directly from your HotelBooking account without prior notice.</p>
                        <p>9.2. By posting a review, you grant HotelBooking the full, perpetual, free, transferable and irrevocable rights to all submitted user content. HotelBooking reserves the right to translate, edit, adjust, refuse or remove reviews at its sole discretion.</p>
                        <p>9.3. You confirm you will comply with these Guest Review Guidelines. In addition, you represent and warrant that</p>
                        <p>9.3.1. you own and control all of the rights to the user content that you post or otherwise distribute, or you otherwise have the lawful right to post and distribute such user content to or through the platform;</p>
                        <p>9.3.2. such content is accurate and not misleading; and</p>
                        <p>9.3.3. use and posting or other transmission of such content does not violate the Terms of Use or any applicable laws and regulations and will not violate any rights of or cause injury to any person or entity.</p>
                        <p>9.4. Reviews may not contain obscenities, profanity, inappropriate content, hate speech and offensive content, promotion of illegal conduct, other people's personal information such as names, phone numbers or email addresses, and irrelevant content such as promotional, invite and reward information. Moreover, reviews may not defame, abuse, harass, or violate the legal rights of others.</p>
                        <p>9.5. You further grant HotelBooking the right to pursue at law any person or entity that violates your or HotelBooking's rights in the content by a breach of the Terms of Use. You agree you will be solely responsible for any user content you provide or submit.</p>
                        <p>9.6. Content submitted by users will be considered non-confidential and HotelBooking is under no obligation to treat such content as proprietary information. Without limiting the foregoing, HotelBooking reserves the right to use the content as it deems appropriate, including, without limitation, deleting, editing, modifying, rejecting, or refusing to post it. HotelBooking is under no obligation to offer you any payment for content that you submit or the opportunity to edit, delete or otherwise modify content once it has been submitted to HotelBooking. HotelBooking shall have no duty to attribute authorship of content to you, and shall not be obligated to enforce any form of attribution by third parties. Please refer to the Terms of Use on the Platform for more details.</p>
                       </div>  
                       <div class="section">
                        <h2>10. Booking Confirmation, Tickets, Vouchers, Fees and Payment</h2>
                        
                        <h3>10.1 Booking Confirmation</h3>
                        <p>10.1.1 Certain Services are stated to be subject to instant confirmation. Other than these Services, any required time for confirmation as stated on the HotelBooking Platform is solely for reference only. Actual time required for confirmation may vary.</p>
                        
                        <h3>10.2 Purchase and Use of the Vouchers</h3>
                        <p>10.2.1 Through the HotelBooking Platform, you may purchase vouchers from HotelBooking for the Services ("Vouchers") offered by the Operators in the various destinations. Subject to the policy of the relevant Operator, you will receive an email confirmation of your purchase that will contain a Voucher confirmation number ("Confirmation Number") and a printable version of your Voucher.</p>
                        <p>10.2.2 In order to use your Voucher, you must appear in person at the meeting point designated by the relevant Operator on time, and present such documents and/or information as may be required by the Operator, that may include your Confirmation Number and/or your printed Voucher. If you fail to appear on time or to provide the required documents or information, no refunds will be granted.</p>
                        <p>10.2.3 An Operator may also require you to provide an identification document bearing your photo in order to use your Voucher. Neither HotelBooking nor the Operator is responsible for lost, destroyed or stolen Vouchers or Confirmation Numbers. Vouchers will be void if the relevant Services to be provided are prohibited by law. If you attempt to use a Voucher in an unlawful manner (e.g., you attempt to use a Voucher for wine tasting when you are under the legal age to do so), the respective Operator may refuse to accept your Voucher, and no refunds will be granted.</p>
                        
                        <h3>10.3 Terms of the Vouchers</h3>
                        <p>10.3.1 The Terms of Use for each Voucher may vary amongst Operators and any restrictions that apply to the use of such Voucher, including but not limited to a minimum age requirement, will be conveyed to you at the time of purchase on the HotelBooking Platform.</p>
                        <p>10.3.2 Vouchers are admission tickets to one-time events ('Events'): the date(s) on which a Voucher can be used will be stated on the Voucher. If you do not use your Vouchers on or by the date(s) noted on such Vouchers, except as expressly set forth therein, no refunds will be granted.</p>
                        
                        <h3>10.4 Cancellation of Vouchers</h3>
                        <p>10.4.1 You may cancel your Voucher by contacting HotelBooking customer service within the cancellation period, as stated at the time of purchase on the HotelBooking Platform. Cancelation windows vary on a case by case basis. A Voucher canceled with the required notice will be refunded in full to the credit card you used to purchase such Voucher.</p>
                        <p>10.4.2 The Operator, not HotelBooking, is the offer of the Services for the Events, to which the Vouchers correspond to, and is solely responsible for accepting or rejecting any Voucher you purchase, as related to all such Services.</p>
                        <p>10.4.3 Please directly consult with the Operator if you have any enquiries or complaints in respect of the Service you received in connection with your Voucher. Except as expressly set forth herein, all fees paid for Vouchers are non-refundable. Prices quoted for Vouchers are in the currency stated on the HotelBooking Platform at the time prior to purchase.</p>
                        <p>10.4.4 If an Event which you have purchased a Voucher for is canceled by the Operator, HotelBooking will notify you as soon as reasonably practicable, and will process a full refund to the credit card you used to purchase such Voucher.</p>
                        
                        <h3>10.5 Required Assistance</h3>
                        <p>10.5.1 If you attempt to use a Voucher in accordance with this Terms of Use and the additional terms and conditions applicable to such Voucher and you are unable to do so (due to the fault of the Operator or otherwise), please contact HotelBooking at support@HotelBooking.com, and HotelBooking will try to liaise with the Operator for an appropriate remedy.</p>
                        
                        <h3>10.6 Additional Charges</h3>
                        <p>10.6.1 HotelBooking reserves the right to require payment of fees or charges for any Services offered by HotelBooking. You shall pay all applicable fees or charges, as described on the HotelBooking Platform in connection with such Services selected by you.</p>
                        
                        <h3>10.7 Modifications to Charges</h3>
                        <p>10.7.1 HotelBooking reserves the right to change its price list for fees or charges at any time, upon notice to you, which may be sent to you by email or posted on the HotelBooking Platform. Your use, or continued use, of the Services offered by HotelBooking following such notification constitutes your acceptance of any new or revised fees or charges.</p>
                        
                        <h3>10.8 HotelBooking's Rights and Obligations</h3>
                        <p>10.8.1 HotelBooking reserves the right to deny and cancel bookings or purchases of any Services that are deemed in violation of this policy. Such a determination is at HotelBooking's sole discretion.</p>
                        <p>10.8.2 HotelBooking intends to offer or procure the Operators to offer the Services to you at the best price available on the market. You acknowledge and agree that all taxes and additional fees for particular Services that may be payable for using the Services are expressly excluded in determining the best price.</p>
                        <p>10.8.3 Whilst the Operators are required to provide HotelBooking with accurate and updated prices of the Services on the HotelBooking Platform, HotelBooking cannot guarantee that all prices for the Services provided by the Operators are accurate and updated at all times.</p>
                        <p>10.9 The above terms and conditions & return policies are applicable to all HotelBooking users worldwide.</p>
                    </div>
                        
                        
                        <div class="last-updated">
                            <p>Last updated on 22 June 2025.</p>
                            <p>English (International)</p>
                            <p>© 2025 HotelBooking. All rights reserved.</p>
                        </div>
                    </body>
                    </html>
            """
        webViewData.loadHTMLString(htmlString, baseURL: nil)
    }
    
    private func loadAboutUsHTML() {
        guard let base64Image = base64StringFromAsset(named: "1") else { return }
        let htmlString = """
              <html>
                    <head>
                        <style>
                            body { font-family: sans-serif; padding: 16px; }
                            h3, h4, h5 { color: #333333; }
                            img { width: 100%; height: 250px; object-fit: cover; }
                            .content-body { margin-top: 16px; }
                        </style>
                    </head>
                    <body>
                        <div class="content-section" id="about">
                            <div class="content-header">
                                <h4 class="content-title">About Us</h4>
                            </div>
                            <div class="content-body">
                                <div class="text-center mb-2">
                                     <img src="data:image/jpeg;base64,\(base64Image)" alt="Company Logo">
                                    <h3>Your Hotel Booking Partner Since 2010</h3>
                                </div>
                                       
                                        <p>We are a leading online hotel booking platform dedicated to helping travelers find their perfect accommodations worldwide. With over 1 million properties in our database and partnerships with hotels across 190 countries, we offer unparalleled choice and convenience to our customers.</p>
                                       
                                        <p>Our mission is to make travel planning simple, transparent, and enjoyable. We believe that finding the right place to stay should be as exciting as the journey itself.</p>
                                       
                                        <h5 class="mt-4 mb-3">Our Values</h5>
                                        <div class="row g-4 mb-4">
                                            <div class="col-md-4">
                                                <div class="card h-100 text-center p-3">
                                                    <div class="card-body">
                                                        <i class="fas fa-handshake fa-2x text-primary mb-3"></i>
                                                        <h5>Trust</h5>
                                                        <p class="small">Building relationships based on honesty and reliability</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="card h-100 text-center p-3">
                                                    <div class="card-body">
                                                        <i class="fas fa-globe fa-2x text-primary mb-3"></i>
                                                        <h5>Diversity</h5>
                                                        <p class="small">Embracing different cultures and perspectives</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="card h-100 text-center p-3">
                                                    <div class="card-body">
                                                        <i class="fas fa-leaf fa-2x text-primary mb-3"></i>
                                                        <h5>Sustainability</h5>
                                                        <p class="small">Promoting responsible travel and eco-friendly options</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                       
                                       
                                    </div>
                                </div>
                                 </body>
                    </html>
            """
        webViewData.loadHTMLString(htmlString, baseURL: nil)
        

    }
    private func loadPrivacyPolicyHTML() {
        let htmlString = """
             <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            line-height: 1.6;
                            color: #333;
                            padding: 5px;
                            max-width: 100%;
                            word-wrap: break-word;
                            background-color: transparent;
                        }
                        h1 {
                            font-size: 1.5em;
                            color: #2c3e50;
                            margin-bottom: 16px;
                        }
                        h2 {
                            font-size: 1.3em;
                            color: #2c3e50;
                            margin-top: 24px;
                            margin-bottom: 12px;
                        }
                        h3 {
                            font-size: 1.1em;
                            color: #2c3e50;
                            margin-top: 18px;
                            margin-bottom: 8px;
                        }
                        p {
                            margin-bottom: 12px;
                        }
                        a {
                            color: #3498db;
                            text-decoration: none;
                        }
                        .section {
                            margin-bottom: 24px;
                        }
                        .subsection {
                            margin-bottom: 16px;
                        }
                        .last-updated {
                            font-size: 0.9em;
                            color: #7f8c8d;
                            margin-top: 24px;
                            text-align: right;
                        }
                        ul {
                            padding-left: 20px;
                            margin-bottom: 12px;
                        }
                        li {
                            margin-bottom: 8px;
                        }
                    </style>
                </head>
                <body>
                    <h1>Privacy Policy & Data Management</h1>
                    
                    <div class="section">
                        <p>At HotelBooking, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.</p>
                    </div>
                    
                    <div class="section">
                        <h2>1. Information We Collect</h2>
                        <div class="subsection">
                            <h3>Personal Information</h3>
                            <p>We may collect personal information that can identify you, including:</p>
                            <ul>
                                <li>Name, email address, phone number</li>
                                <li>Payment information (processed securely by our payment partners)</li>
                                <li>Booking details and preferences</li>
                                <li>Account credentials</li>
                            </ul>
                        </div>
                        
                        <div class="subsection">
                            <h3>Usage Data</h3>
                            <p>We automatically collect information about how you interact with our app:</p>
                            <ul>
                                <li>Device information (type, OS, unique identifiers)</li>
                                <li>Log data (IP address, access times, app features used)</li>
                                <li>Cookies and similar tracking technologies</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="section">
                        <h2>2. How We Use Your Information</h2>
                        <p>We use the information we collect for the following purposes:</p>
                        <ul>
                            <li>To provide and maintain our services</li>
                            <li>To process your bookings and transactions</li>
                            <li>To communicate with you about your account and bookings</li>
                            <li>To improve our app and services</li>
                            <li>To personalize your experience</li>
                            <li>To comply with legal obligations</li>
                            <li>To prevent fraud and enhance security</li>
                        </ul>
                    </div>
                    
                    <div class="section">
                        <h2>3. Data Sharing and Disclosure</h2>
                        <p>We may share your information in the following situations:</p>
                        <ul>
                            <li><strong>With Hotels:</strong> To fulfill your bookings and reservations</li>
                            <li><strong>Service Providers:</strong> With companies that help us operate our business (payment processors, analytics, customer support)</li>
                            <li><strong>Legal Requirements:</strong> When required by law or to protect our rights</li>
                            <li><strong>Business Transfers:</strong> In connection with a merger, acquisition, or sale of assets</li>
                        </ul>
                        <p>We do not sell your personal information to third parties.</p>
                    </div>
                    
                    <div class="section">
                        <h2>4. Data Security</h2>
                        <p>We implement appropriate technical and organizational measures to protect your personal information, including:</p>
                        <ul>
                            <li>Encryption of sensitive data</li>
                            <li>Secure servers and networks</li>
                            <li>Regular security assessments</li>
                            <li>Access controls</li>
                        </ul>
                        <p>However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.</p>
                    </div>
                    
                    <div class="section">
                        <h2>5. Your Data Rights</h2>
                        <p>Depending on your location, you may have the following rights regarding your personal data:</p>
                        <ul>
                            <li><strong>Access:</strong> Request a copy of your personal data</li>
                            <li><strong>Correction:</strong> Request correction of inaccurate data</li>
                            <li><strong>Deletion:</strong> Request deletion of your personal data</li>
                            <li><strong>Restriction:</strong> Request restriction of processing</li>
                            <li><strong>Portability:</strong> Request transfer of your data to another service</li>
                            <li><strong>Objection:</strong> Object to certain processing activities</li>
                        </ul>
                        <p>To exercise these rights, please contact us at privacy@hotelbooking.com.</p>
                    </div>
                    
                    <div class="section">
                        <h2>6. Data Retention</h2>
                        <p>We retain your personal information only as long as necessary to:</p>
                        <ul>
                            <li>Provide you with our services</li>
                            <li>Comply with legal obligations</li>
                            <li>Resolve disputes</li>
                            <li>Enforce our agreements</li>
                        </ul>
                        <p>Booking information is typically retained for 5 years for legal and accounting purposes.</p>
                    </div>
                    
                    <div class="section">
                        <h2>7. International Data Transfers</h2>
                        <p>Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place for these transfers in accordance with applicable data protection laws.</p>
                    </div>
                    
                    <div class="section">
                        <h2>8. Children's Privacy</h2>
                        <p>Our services are not directed to individuals under 16. We do not knowingly collect personal information from children under 16. If we become aware of such collection, we will take steps to delete the information.</p>
                    </div>
                    
                    <div class="section">
                        <h2>9. Changes to This Policy</h2>
                        <p>We may update this Privacy Policy from time to time. We will notify you of significant changes through the app or by email. Your continued use of our services after such changes constitutes your acceptance of the new policy.</p>
                    </div>
                    
                    <div class="section">
                        <h2>10. Contact Us</h2>
                        <p>If you have any questions about this Privacy Policy or our data practices, please contact us at:</p>
                        <p>Email: privacy@hotelbooking.com<br>
                        Address: Data Protection Officer, HotelBooking Inc., 123 Privacy Lane, Data City, DC 10101</p>
                    </div>
                    
                    <div class="last-updated">
                        <p>Last updated on 22 June 2025.</p>
                        <p>English (International)</p>
                        <p>© 2025 HotelBooking. All rights reserved.</p>
                    </div>
                </body>
                </html>
            """
        webViewData.loadHTMLString(htmlString, baseURL: nil)
    }
}
