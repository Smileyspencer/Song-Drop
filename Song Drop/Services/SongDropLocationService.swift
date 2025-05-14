//
//  SongDropLocationManager.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/5/24.
//

import Foundation
import MapKit

class SongDropLocationService: NSObject {
    
    enum DefaultRegions {
        case standard
        
        func value() -> MKCoordinateRegion {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.730610,
                                                                     longitude: -73.935242),
                                      span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                             longitudeDelta: 0.01))
        }
    }
    
    enum LocationManagerEnabledStatus {
        case off, notAuthorized, authorized
    }
    
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        Task {
            await refreshLocationManager()
        }
    }
    
    /// When location services are manually turned off in setting.
    private func determineLocationServicesAvailable() async -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// When permissions for location services in this app are denied.
    private func determineLocationServicesAuthorizedForUse() -> LocationManagerEnabledStatus {
        guard let locationManager = locationManager else {
            return .off
        }
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            return .notAuthorized
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        default:
            return .notAuthorized
        }
    }
    
    /// Composite function allowing visibility into current location availability.
    func locationAvailable() async -> LocationManagerEnabledStatus {
        guard await determineLocationServicesAvailable() else {
            return .off
        }
        
        // Set location manager if it's not been set.
        if locationManager == nil {
            await refreshLocationManager()
        }
        return determineLocationServicesAuthorizedForUse()
    }

    /// Assign the location manager.
    func refreshLocationManager() async {
        if await determineLocationServicesAvailable() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.delegate = self
        }
    }
    
    func currentRegion() -> MKCoordinateRegion {
        guard let location = locationManager?.location else {
            return SongDropLocationService.DefaultRegions.standard.value()
        }
        
        return MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    func currentLocation() -> CLLocationCoordinate2D {
        guard let location = locationManager?.location else {
            return CLLocationCoordinate2D(latitude: 40.730610,
                                          longitude: -73.935242)
        }
        
        return location.coordinate
    }
    
}

extension SongDropLocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task {
            await refreshLocationManager()
        }
    }
}
