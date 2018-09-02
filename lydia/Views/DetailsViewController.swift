//
//  DetailsViewController.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var pictureActivity: UIActivityIndicatorView!
    @IBOutlet weak var pictureOutline: UIView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var pseudo: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var map: MKMapView!

    let pictureQueue = DispatchQueue(label: "picturequeue")
    var pinAnnotation: MKPointAnnotation?
    var timer: Timer!

    var user: UserViewModel? {
        didSet {
            if isViewLoaded {
                scrollView.isHidden = user == nil
                emptyLabel.isHidden = user != nil
                if let user = user {
                    refreshUser(user)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picture.layer.borderWidth = 2
        picture.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        picture.layer.cornerRadius = picture.bounds.width / 2.0
        picture.layer.masksToBounds = true
        pictureOutline.layer.cornerRadius = picture.bounds.width / 2.0
        pictureOutline.layer.shadowRadius = 2
        pictureOutline.layer.shadowOpacity = 0.3
        pictureOutline.layer.shadowOffset = CGSize(width: 0, height: 2)
        pictureOutline.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        scrollView.isHidden = user == nil
        emptyLabel.isHidden = user != nil
        if let user = user {
            refreshUser(user)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    @IBAction func showPassword(_ sender: Any) {
        password.isSecureTextEntry = !password.isSecureTextEntry
    }

    @objc func timerFired(_ timer: Timer) {
        if user == nil {
            return
        }
        let showSeparators = Calendar.current.dateComponents([.second], from: Date()).second! % 2 == 0
        time.text = user?.currentTime(showSeparators: showSeparators)
    }
    
    func refreshUser(_ user: UserViewModel) {
        name.text = user.name + " " + user.flag
        birthday.text = user.birthday
        gender.image = user.gender == .male ? #imageLiteral(resourceName: "male") : #imageLiteral(resourceName: "female")
        email.text = user.email
        phone.text = user.phone
        address.text = user.address
        pseudo.text = user.pseudo
        password.text = user.password
        if let pin = pinAnnotation {
            map.removeAnnotation(pin)
        }
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(user.latitude), CLLocationDegrees(user.longitude))
        pinAnnotation = MKPointAnnotation()
        pinAnnotation!.coordinate = coordinate
        map.addAnnotation(pinAnnotation!)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40))
        map.setRegion(region, animated: false)
 
        pictureActivity.startAnimating()
        pictureQueue.async { [weak self] in
            guard let url = URL(string: user.picture),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self?.pictureActivity.stopAnimating()
                        self?.picture.isHidden = true
                    }
                    return
            }
            DispatchQueue.main.async {
                self?.pictureActivity.stopAnimating()
                self?.picture.image = image
            }
        }
    }
}

extension DetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
