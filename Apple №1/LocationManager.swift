//
//  LocationManager.swift
//  Apple №1
//
//  Created by Steven Kirke on 11.03.2024.
//

import Foundation
import CoreLocation

protocol ILocationManager: AnyObject {
	func getLocation(resultCoordinate: @escaping (Result<CLLocationCoordinate2D, ErrorCurrentLocation>) -> Void) async
}

enum ErrorCurrentLocation: LocalizedError {
	case convertLocation
	case requestLocation

	var errorDescription: String? {
		var textError = ""
		switch self {
		case .convertLocation:
			textError = "Invalid convert current location."
		case .requestLocation:
			textError = "Invalid request current location."
		}
		return textError
	}
}

final class LocationManager: ILocationManager {

	// MARK: - Dependencies
	let locationManager = CLLocationManager()

	// MARK: - Public methods
	func getLocation(resultCoordinate: @escaping (Result<CLLocationCoordinate2D, ErrorCurrentLocation>) -> Void) {
		self.location { coordinate in
			resultCoordinate(coordinate)
		}
	}

	// MARK: - Private methods
	private func location(resultCoordinate: @escaping (Result<CLLocationCoordinate2D, ErrorCurrentLocation>) -> Void) {
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()

		switch CLLocationManager().authorizationStatus {
		case .authorizedWhenInUse, .authorizedAlways:
			guard let coordinate = locationManager.location?.coordinate else {
				resultCoordinate(.failure(.convertLocation))
				return
			}
			resultCoordinate(.success(coordinate))
		default:
			resultCoordinate(.failure(.requestLocation))
		}

	}
}
