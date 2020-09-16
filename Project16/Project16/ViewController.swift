//
//  ViewController.swift
//  Project16
//
//  Created by Ivan Ivanušić on 16/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change map", style: .plain, target: self, action: #selector(changeMap))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of the Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
            annotationView?.pinTintColor = .blue
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Wiki", style: .default, handler: {
            _ in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.city = placeName
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        present(ac, animated: true)
    }
    
    @objc func changeMap() {
        let ac = UIAlertController(title: "Change map", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: {
            _ in
            self.mapView.mapType = .hybrid
            self.mapView.reloadInputViews()
        }))
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: {
            _ in
            self.mapView.mapType = .hybridFlyover
            self.mapView.reloadInputViews()
        }))
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default, handler: {
            _ in
            self.mapView.mapType = .mutedStandard
            self.mapView.reloadInputViews()
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: {
            _ in
            self.mapView.mapType = .satellite
            self.mapView.reloadInputViews()
        }))
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: {
            _ in
            self.mapView.mapType = .satelliteFlyover
            self.mapView.reloadInputViews()
        }))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: {
            _ in
            self.mapView.mapType = .standard
            self.mapView.reloadInputViews()
        }))
        
        present(ac, animated: true)
    }

}

