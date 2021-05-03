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
        
        self.navigationItem.title = "On The Map"
      /*  self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "Logo"), style: .plain, target: self, action: #selector(addPin)), UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))]
        self.refresh()*/
    }
    
   // @objc func addPin() {
     //   self.performSegue(withIdentifier: "getLocation2", sender: nil)
   // }
    
  //  @objc func refresh() {
         //   OTM.getStudentLocation(completion: self.handleGetLocation(success:error:))
  //      }

}
