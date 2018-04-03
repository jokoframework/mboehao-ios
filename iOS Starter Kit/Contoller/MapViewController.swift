//
//  MapViewController.swift
//  iOS Starter Kit
//
//  Created by nessvaldez on 3/12/18.
//  Copyright © 2018 Sodep. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    let mapsbutton = UIButton(type: .custom)
    var currentSelectedMarker: CLLocationCoordinate2D?
    override func viewDidLoad() {
        self.navigationItem.title = "Mapa"
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        setMapPreferences()
        loadCoordinates()
        createDirectionsButton()
    }
    func setMapPreferences() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        let camera = GMSCameraPosition(target: (locationManager.location?.coordinate)!, zoom: 10.0, bearing: 0, viewingAngle: 0)
        mapView.camera = camera
    }
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D,
                                          completionHandler: @escaping ([String]) -> Void) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, _) in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            //completionHandler(lines.joined(separator: "\n"))
            completionHandler(lines)
        }
    }
    func loadCoordinates() {

        let markers: JSON = [
            ["latitude": -25.347673, "longitude": -57.430284, "icon": "atm"],
            ["latitude": -25.343640, "longitude": -57.504099, "icon": "dog"],
            ["latitude": -25.332314, "longitude": -57.619284, "icon": "atm"],
            ["latitude": -25.286224, "longitude": -57.561434, "icon": ""],
            ["latitude": -25.269926, "longitude": -57.553538, "icon": "atm"],
            ["latitude": -25.272254, "longitude": -57.598170, "icon": "atm"]
        ]
        for (_, subJson) in markers {
            if let position = Coordinate(json: subJson) {
                addMarker(position)
            }
        }
    }
    func addMarker(_ position: Coordinate) {
        DispatchQueue.main.async {
            let coordinate: CLLocationCoordinate2D = position.convertToCLLocationCoordinate2D()
            let marker = GMSMarker(position: coordinate)
            marker.appearAnimation = GMSMarkerAnimation.pop
            if let icon = UIImage(named: position.icon!) {
                marker.icon = icon
            }
            self.reverseGeocodeCoordinate(coordinate) { (lines) in
                marker.title = lines[0]
                marker.snippet = lines[1]
            }
            marker.map = self.mapView
        }
    }
    func createDirectionsButton() {
        view.addSubview(mapsbutton)
        mapsbutton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 130, right: 10),
                          size: .init(width: 57, height: 57))
        mapsbutton.cornerRadius = 28.5
        mapsbutton.clipsToBounds = true
        mapsbutton.backgroundColor = Constants.UI.Colors.PrimaryColor
        mapsbutton.setImage(UIImage(named: "navigation"), for: .normal)
        mapsbutton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mapsbutton.addTarget(self, action: #selector(mapsButtonAction), for: .touchUpInside)
        mapsbutton.isHidden = true
    }
    @objc func mapsButtonAction() {
        if(UIApplication.shared.canOpenURL(URL(string: Constants.URL.MapsURL)!)) {
            UIApplication.shared.open(Constants.URL.mapsURLDirections(latitude: (currentSelectedMarker?.latitude)!,
                                                                      longitude: (currentSelectedMarker?.longitude)!) as URL,
                                      options: [:], completionHandler: nil)
        } else {
            NSLog("No se pudo abrir google maps")
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
        mapView.animate(to: GMSCameraPosition.camera(withTarget: marker.position, zoom: 15.0))
        CATransaction.commit()
        mapsbutton.alpha = 0
        mapsbutton.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.mapsbutton.alpha = 1
        }

        currentSelectedMarker = marker.position
        mapView.selectedMarker = marker
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.5) {
            self.mapsbutton.alpha = 0
        }
        mapsbutton.isHidden = true
        mapView.selectedMarker = nil
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        locationManager.stopUpdatingLocation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        mapView?.isMyLocationEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        mapView?.isMyLocationEnabled = true
    }
}
