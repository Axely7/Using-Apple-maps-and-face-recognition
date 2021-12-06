//
//  ViewController.swift
//  SensorsApp
//
//  Created by ENRIQUE JIMENEZ CORDERO on 05/12/21.
//

import UIKit
import MapKit
import CoreLocation
import LocalAuthentication

class ViewController: UIViewController {
    // MARK: Private Properties
    private var locationManager = CLLocationManager()
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: Actions
    @IBAction func locationButtonPressed(_ sender: Any) {
        authenticateUser()
    }
    
    // MARK: Private Methods
    private func setUpUI(){
        errorLabel.isHidden = true
    }
    
    
    private func authenticateUser(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success{
                        self.errorLabel.isHidden = true
                        self.getCurrentLocation()
                    } else {
                        self.errorLabel.isHidden = false
                    }
                }
            }
        } else {
            print("No biometry")
        }
    }
    
    // MARK: Private Methods
    private func getCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
}


extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        //let region = MKCoordinateRegion(center: center, latitudinalMeters: 0.01, longitudinalMeters: 0.01)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        mapView.addAnnotation(pin)
    }
}

