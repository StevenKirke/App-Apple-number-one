//
//  MainContactIterator.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import Foundation

protocol IMainContactIterator: AnyObject {
	func fitchAddresses()
	func fitchCurrentLocation()
	func fitchMap(coordinate: MainContactModel.Request.Coordinates)
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

	func fitchMap(coordinate: MainContactModel.Request.Coordinates) {
		worker.getMapForLocation(coordinate: coordinate) { [weak self] resultData in
			guard let self = self else { return }
			switch resultData {
			case .success(let data):
				self.presenter.presentMap(presentMap: .showMap(data))
			case .failure(let error):
				self.presenter.presentMap(presentMap: .failure(error))
			}
		}
	}

	func fitchCurrentLocation() {
		Task.init {
			await self.worker.getCurrentLocation()
		}
	}
}
