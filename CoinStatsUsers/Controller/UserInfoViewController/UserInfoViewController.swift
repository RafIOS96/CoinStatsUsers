//
//  UserInfoViewController.swift
//  CoinStatsUsers
//
//  Created by Rafayel Aghayan on 10.04.21.
//

import UIKit
import MapKit
import MessageUI
import CoreLocation
import SafariServices

class UserInfoViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var user_Gender: UILabel!
    @IBOutlet weak var user_Email: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    
    var long = ""
    var lat = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.layer.frame.size.height/2
        userImage.downloaded(from: picture?["medium"] ?? "")
        
        coordinates = location?["coordinates"] as? [String: Any]
        lat = (coordinates?["latitude"] as? String) ?? ""
        long = (coordinates?["longitude"] as? String) ?? ""
        userAddress.text = userFullAddress
        
        self.user_Email.text = userEmail
        self.userPhoneNumber.text = userPhone
        self.userAge.text = String(dob?["age"] as? Int ?? 0)
        self.user_Gender.text = userGender
        
        let cordinate = CLLocationCoordinate2D(latitude: (lat as NSString).doubleValue,
                                               longitude: (long as NSString).doubleValue)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: cordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = cordinate
        mapView.addAnnotation(pin)
        
        addRightNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = (name?["first"] ?? "") + " " + (name?["last"] ?? "")
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        showMailComposer()
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        guard let number = URL(string: "tel://" + (userPhone ?? "")) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func heartSelected(_ sender: UIButton) {
        
        if sender.isSelected
        {
            sender.isSelected = false
            indexArray[selectedIndex!] = false
        } else {
            sender.isSelected = true
            indexArray[selectedIndex!] = true
        }
    }
    
    func addRightNavigationItem() {
        let heartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        heartButton.setImage(UIImage(named: "heartFill"), for: .normal)
        heartButton.setImage(UIImage(named: "heart"), for: .selected )
        
        if favorite == true {
            heartButton.isSelected = true
        } else {
            heartButton.isSelected = false
        }
      
        heartButton.addTarget(self, action: #selector(heartSelected), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
    }
    
    func showLocationInMap() {
        let annontation = MKPointAnnotation()
        annontation.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        mapView.addAnnotation(annontation)
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            let alert = UIAlertController(title: "Alert",
                                          message: "You must to Log in your mail app on your phone for sending mail",
                                          preferredStyle: .alert)
                
                 let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                    if let url = URL(string: "https://www.google.com") {
                        UIApplication.shared.openURL(url)
                    }
                 })
                 alert.addAction(ok)
                 DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true)
            })
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["rafael.aghayann@gmail.com"])
        composer.setSubject("Good job!")
        composer.setMessageBody("Message ...", isHTML: false)
        
        present(composer, animated: true, completion: nil)
    }
}

extension UserInfoViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
        }
        
        switch result {
        case .cancelled:
            print("canceled")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("Email sent")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
