//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 15.05.21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!    
    @IBOutlet weak var profileLinkTextField: UITextField!
    
    var segueIdentifier: String = ""

    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           locationTextField.text = ""
           profileLinkTextField.text = ""
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        print("findLocationButton0")

        if (self.profileLinkTextField.text != "") {
            print("findLocationButton")
            self.findLocation()
        }
        else {
            self.showFindLocationFailure(message: "Link is Empty")
        }
    }
    
    func findLocation() {
        CLGeocoder().geocodeAddressString((self.locationTextField.text ?? ""), completionHandler: handleFindLocation(placemarks:error:))
    }
    
    func handleFindLocation(placemarks: [CLPlacemark]?, error: Error?) {
       // setGeocoding(false)
        if (placemarks != nil) {
            print("Geocoding Successful0")
            appDelegate.placemark = placemarks?[0]
            appDelegate.mapString = self.locationTextField.text
            appDelegate.mediaURL = self.profileLinkTextField.text
            print("Geocoding Successful1")

            self.performSegue(withIdentifier: "tabAddLocation", sender: nil)
            print("Geocoding Successful2")
        }
        else {
            showFindLocationFailure(message: "Geocoding Failed")
        }
    }
    
    func showFindLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated:true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let alvc = segue.destination as! AddLocationViewController
        alvc.segueIdentifier = segueIdentifier
    }
}
