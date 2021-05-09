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
    
}

