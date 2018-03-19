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
    private let locationManager = CLLocationManager()
    var addressLabel: String? = "Buscando ubicación.."
    let addressView = UILabel()
    var mapView: GMSMapView?
    let mapsbutton = UIButton(type: .custom)
    var currentSelectedMarker: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        setMapUI()
        loadCoordinates()
        createDirectionsButton()
        //setAddressLabelView()
    }
    private func setMapUI() {
        let frame = CGRect(x: view.frame.origin.x, y: Constants.UI.Size.StatusBar,
                           width: view.frame.size.width,
                           height: view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - Constants.UI.Size.StatusBar)
        let camera = GMSCameraPosition.camera(withTarget: (locationManager.location?.coordinate)!, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: frame, camera: camera)
        self.mapView!.delegate = self
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(mapView!)
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
    func setAddressLabelView() {
        let yAxis = self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - 60
        addressView.frame = CGRect(x: 0, y: yAxis, width: self.view.frame.size.width, height: 60)
        addressView.textAlignment = NSTextAlignment.center
        addressView.backgroundColor = UIColor.white
        addressView.shadowOpacity = 0.85
        addressView.numberOfLines = 0
        addressView.text = addressLabel
        self.view.addSubview(addressView)
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
        let frame = CGRect(x: view.frame.size.width - 66,
        y: view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)! - 130,
        width: 57, height: 57)
        mapsbutton.frame = frame
        mapsbutton.layer.cornerRadius = 0.5 * mapsbutton.bounds.size.width
        mapsbutton.clipsToBounds = true
        mapsbutton.backgroundColor = UIColor.lightGray
        mapsbutton.setImage(UIImage(named: "navigation"), for: .normal)
        mapsbutton.backgroundColor = Constants.UI.Colors.NavigationColor
        mapsbutton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mapsbutton.addTarget(self, action: #selector(mapsButtonAction), for: .touchUpInside)
        mapsbutton.isHidden = true
        self.view.addSubview(mapsbutton)
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
        mapsbutton.isHidden = false
        CATransaction.commit()
        currentSelectedMarker = marker.position
        mapView.selectedMarker = marker
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapsbutton.isHidden = true
        mapView.selectedMarker = nil
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.startUpdatingLocation()
    }
}
