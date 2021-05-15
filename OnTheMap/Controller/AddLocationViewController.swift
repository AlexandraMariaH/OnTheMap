//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 06.05.21.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addLocation: UINavigationItem!
    
    var firstName: String = ""
    var lastName: String = ""
    var segueIdentifier: String = ""
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishAddLocation(_ sender: UIButton) {
        self.createStudentLocation()
    }
    
    func createStudentLocation() {
        OTMClient.createStudentLocation(firstName: firstName, lastName: lastName, mapString: appDelegate.mapString ?? "", mediaURL: appDelegate.mediaURL ?? "", latitude: (appDelegate.placemark?.location!.coordinate.latitude)!, longitude: (appDelegate.placemark?.location!.coordinate.longitude)!, completion: self.handleCreateStudentLocation(success:error:))
    }
    
    func handleCreateStudentLocation(success: Bool, error: Error?) {
      if (success) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
        self.dismiss(animated: true, completion: nil)
      }
      else {
        showFailure(failureType: "Can not create Student Location", message: error?.localizedDescription ?? "")
      }
    }
    
    func showFailure(failureType: String, message: String) {
        let alertVC = UIAlertController(title: failureType, message: message, preferredStyle: .alert)
         alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alertVC, animated:true)
    }
    
   
    
}

