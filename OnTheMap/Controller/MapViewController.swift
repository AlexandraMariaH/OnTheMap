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
        refreshAtStart()
    }
    
    func refreshAtStart() {
        OTMClient.getStudentLocation(completion: self.handleGetStudentLocation(success:error:))
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
         OTMClient.getStudentLocation(completion: self.handleGetStudentLocation(success:error:))
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        OTMClient.logout {
            DispatchQueue.main.async {
              self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func handleGetStudentLocation(success: Bool, error: Error?) {
        if (success) {
            self.drawMap()        }
        else {
            showGetStudentLocationFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func drawMap() {
       
       var annotations = [MKPointAnnotation]()
       
       for i in 0..<OTMModel.student.count

       {
        let lat = CLLocationDegrees(OTMModel.student[i].latitude )
        let long = CLLocationDegrees(OTMModel.student[i].longitude )
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                   
        let first = OTMModel.student[i].firstName
        let last = OTMModel.student[i].lastName
        let mediaURL = OTMModel.student[i].mediaURL
       
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
                   
        annotations.append(annotation)
       }
               
    self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    func showGetStudentLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Unable to download student information", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated:true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let ipvc = segue.destination as! InformationPostingViewController
        ipvc.segueIdentifier = "unwindToMap"
    }
    
    @IBAction func unwindToMap(segue:UIStoryboardSegue) { }

    
}
