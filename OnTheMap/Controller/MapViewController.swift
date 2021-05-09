//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 03.05.21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var addPin: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    @IBAction func refreshTapped(_ sender: UIButton) {
        // OTMClient.getStudentLocation(completion: self.handleGetLocation(success:error:))
        print("refreshtapped")
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        print("logouttapped")
        OTMClient.logout {
            DispatchQueue.main.async {
              self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
