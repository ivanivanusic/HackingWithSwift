//
//  ViewController.swift
//  Project22
//
//  Created by Ivan Ivanušić on 28/09/2020.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    @IBOutlet var circle: UIImageView!
    var locationManager: CLLocationManager?
    var isAlertShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        beaconName.isHidden = true
        beaconName.layer.zPosition = 1
        distanceReading.layer.zPosition = 1
        circle.layer.cornerRadius = 128
        circle.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if !isAlertShown {
                let ac = UIAlertController(title: "First beacon detected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true)
                isAlertShown = true
            }
            beaconName.text = beacon.proximityUUID.uuidString
            beaconName.isHidden = false
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
            beaconName.isHidden = true
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.circle.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1)
                self.distanceReading.text = "UNKNOWN"

            case .far:
                self.circle.layer.transform = CATransform3DMakeScale(0.25, 0.25, 1)
                self.distanceReading.text = "FAR"

            case .near:
                self.circle.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
                self.distanceReading.text = "NEAR"

            case .immediate:
                self.circle.layer.transform = CATransform3DMakeScale(1, 1, 1)
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.circle.layer.transform = CATransform3DMakeScale(0.65, 0.65, 1)
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
}

