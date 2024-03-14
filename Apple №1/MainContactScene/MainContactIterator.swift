//
//  MainContactIterator.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import Foundation
import CoreLocation

typealias CoordinateR = MainContactModel.Request.FlagCoordinates

protocol IMainContactIterator: AnyObject {
	func fitchAddresses()
	func fitchCurrentLocation()
	func fitchDistance(currentCoordinate: CoordinateR, coordinate: CoordinateR)
}

final class MainContactIterator {

	// MARK: - Dependencies
	let presenter: IMainContactPresenter
	let worker: IMainContactWorker

	// MARK: - Initializator
	internal init(
		presenter: IMainContactPresenter,
		worker: IMainContactWorker
	) {
		self.presenter = presenter
		self.worker = worker
	}
}

extension MainContactIterator: IMainContactIterator {
	func fitchAddresses() {
		worker.getAddressList { [weak self] resultAddress in
			guard let self = self else { return }
			switch resultAddress {
			case .success(let addresses):
				self.presenter.presentAddresses(presentAddress: .showAddress(addresses))
			case .failure(let error):
				self.presenter.presentAddresses(presentAddress: .failure(error))
			}
		}
	}

	func fitchCurrentLocation() {
		Task.init {
			await self.worker.getCurrentLocation { [weak self] resultLocation in
				guard let self = self else { return }
				switch resultLocation {
				case .success(let coordinate):
					let model = MainContactModel.Response.showCurrentCoordinate(
						MainContactModel.Response.Coordinates(
							latitude: coordinate.latitude,
							longitude: coordinate.longitude
						)
					)
					self.presenter.presentCurrentLocation(presentCurrentLocation: model)
				case .failure(let error):
					self.presenter.presentCurrentLocation(presentCurrentLocation: .failure(error))
				}
			}
		}
	}

	func fitchDistance(currentCoordinate: CoordinateR, coordinate: CoordinateR) {
		DispatchQueue.main.async {
			print("Coordinate - currentCoordinate: \(currentCoordinate) coordinate: \(coordinate)")
			let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
			let workShopLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
			let distance = workShopLocation.distance(from: currentLocation)
			let distanceKM = (distance / 1000).rounded()
			self.presenter.presentDistance(presentDistance: .showDistance(distanceKM))
		}
	}
}
