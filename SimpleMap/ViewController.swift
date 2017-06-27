//
//  ViewController.swift
//  SimpleMap
//
//  Created by Matthew Howes Singleton on 6/26/17.
//  Copyright © 2017 Matthew Howes Singleton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapVw: MKMapView!
    
    var locationManager = CLLocationManager()
    var userLocationAdded = false
    var localSearchRequest = MKLocalSearchRequest()
    //var localSearch = MKLocalSearch()
    //var localSearchRepsonse = MKLocalSearchResponse()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapVw.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !userLocationAdded {
            if let myLocation = locations.first {
                let annotation = MKPointAnnotation()
                annotation.coordinate = myLocation.coordinate
                annotation.title = "My Location"
                self.mapVw.addAnnotation(annotation)
                userLocationAdded = true
                self.mapVw.showAnnotations(self.mapVw.annotations, animated: true)
            }
        }
        
    }
    
}


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response, error) in
            if let theResponse = response {
                self.mapVw.removeAnnotations(self.mapVw.annotations)
                for item in theResponse.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.title
                    self.mapVw.addAnnotation(annotation)
                }
                self.mapVw.showAnnotations(self.mapVw.annotations, animated: true)
            }
            
        }
        
        
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") {
            
            pinView.annotation = annotation
            
            return pinView
        }
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        pinView.canShowCallout = true
        pinView.image = #imageLiteral(resourceName: "E")
        
        pinView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        pinView.centerOffset = CGPoint(x: 0, y: -25)
        
        return pinView
        
    }
    
    
}

