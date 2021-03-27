//
//  MapViewController.swift
//  Minhas Viagens
//
//  Created by Caio Fernandes on 26/03/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    private var listOfObj = Places()
    private var locationManager = CLLocationManager()
    var place: Dictionary<String, String> = [:]
    var isPlaceView: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isPlaceView {
            setupLocationManager()
        } else {
            seePlace()
        }
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.mark(gesture:)))
        gestureRecognizer.minimumPressDuration = 2
        map.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func mark(gesture: UIGestureRecognizer? = nil){
        if gesture?.state == UIGestureRecognizer.State.began{
            let pointSelected = (gesture?.location(in: self.map))!
            let coordinate = map.convert(pointSelected, toCoordinateFrom: self.map)
            saveAdress(coordinate: coordinate)
        }
    }
    
    func setupLocationManager() -> Void {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func seePlace() -> Void {
        let latitude = Double(place["latitude"]!)
        let longitude = Double(place["longitude"]!)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude!
        annotation.coordinate.longitude = longitude!
        annotation.title = place["local"]
        map.addAnnotation(annotation)
        seeLocal(latitude: latitude!, longitude: longitude!)
    }
    
    func seeLocal(latitude: Double, longitude: Double) -> Void {
        let deltaLatitude: CLLocationDegrees = 0.05
        let deltaLongitude: CLLocationDegrees = 0.05
        let location2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let visualizationArea: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location2D, span: visualizationArea)
        map.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocalization = locations.last
        let longitude = userLocalization?.coordinate.longitude
        let latitude = userLocalization?.coordinate.latitude
        seeLocal(latitude: latitude!, longitude: longitude!)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            presentLocationAlertDenied()
        }
    }

    func presentLocationAlertDenied(){
        let alertDenied = UIAlertController(title: "Localization Permission", message: "We need that you allow localization service to app works fine", preferredStyle: .alert)
        
        let configurationAction = UIAlertAction(title: "Open configuration", style: .default, handler: {(UIAlertAction) -> Void in
            
            if let configuration = NSURL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(configuration as URL)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertDenied.addAction(configurationAction)
        alertDenied.addAction(cancelAction)
        
        present(alertDenied, animated: true, completion: nil)
    }
    
    func saveAdress(coordinate: CLLocationCoordinate2D) {
        let longitude = coordinate.longitude
        let latitude = coordinate.latitude
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        var adress = "Adress not found!"
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: nil) { (localDetails, error) in
            if error == nil {
                if let local = localDetails?.first {
                    
                    if let name = local.name{
                        adress = name
                    } else {
                        if let thoroughfare =  local.thoroughfare {
                            adress = thoroughfare
                        }
                    }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = coordinate.latitude
                    annotation.coordinate.longitude = coordinate.longitude
                    annotation.title = adress
                    self.map.addAnnotation(annotation)
                    let place: Dictionary<String, String> = ["local": adress, "latitude": String(latitude), "longitude": String(longitude)]
                    self.listOfObj.add(place: place)
                }
            } else {
                print("ERROR")
            }
        }
    }
}
