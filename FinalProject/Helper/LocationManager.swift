//
//  LocationManager.swift
//  Blank Project
//
//  Created by framgia on 5/25/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: NSObjectProtocol {
    func updateLocation(manager: LocationManager, location: CLLocation)
    func changeStatusLocation(manager: LocationManager, status: CLAuthorizationStatus)
    func updateHeading(manager: LocationManager, heading: CLHeading)
}

extension LocationManagerDelegate {
    func changeStatusLocation(manager: LocationManager, status: CLAuthorizationStatus) {
    }

    func updateHeading(manager: LocationManager, heading: CLHeading) {
    }
}

class LocationManager: NSObject {

    static let shared = LocationManager()
    var location: CLLocation?
    lazy var locationManager = CLLocationManager()
    var timer: Timer?
    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }

    weak var delegate: LocationManagerDelegate?


    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    @objc func gpsOn() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func gpsOff() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }

        guard let oldLocation = location else {
            location = newLocation
            delegate?.updateLocation(manager: self, location: newLocation)
            return
        }

        if oldLocation.coordinate.latitude != newLocation.coordinate.latitude,
            oldLocation.coordinate.longitude != newLocation.coordinate.longitude {
            location = newLocation
            delegate?.updateLocation(manager: self, location: newLocation)
        }

        if status == .authorizedAlways  {
            gpsOff()
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(gpsOn), userInfo: nil, repeats: false)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        delegate?.updateHeading(manager: self, heading: newHeading)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.changeStatusLocation(manager: self, status: status)
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            break
        case .denied:
            break
        default :
            break
        }
    }

}

