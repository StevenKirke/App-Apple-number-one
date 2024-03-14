//
//  MainContactPresenter.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import Foundation

protocol IMainContactPresenter: AnyObject {
	func presentAddresses(presentAddress: MainContactModel.Response)
	func presentCurrentLocation(presentCurrentLocation: MainContactModel.Response)
	func presentDistance(presentDistance: MainContactModel.Response)
}

final class MainContactPresenter {

	// MARK: Dependencies

	// MARK: - Lifecycle
	private weak var viewController: IMainContactViewLogic?

	// MARK: - Initializator
	internal init(viewController: IMainContactViewLogic?) {
		self.viewController = viewController
	}
}

extension MainContactPresenter: IMainContactPresenter {
	func presentAddresses(presentAddress: MainContactModel.Response) {
		if case .showAddress(let address) = presentAddress {
			let modelView = address.map { MainContactModel.ViewModel.AddressWorkShop(from: $0) }
			viewController?.renderAddresses(renderAddress: modelView)
		}
		if case .failure(let error) = presentAddress {
			print("Error Main Contact Presenter \(error)")
		}
	}

	func presentCurrentLocation(presentCurrentLocation: MainContactModel.Response) {
		if case .showCurrentCoordinate(let coordinate) = presentCurrentLocation {
			let model = MainContactModel.ViewModel.Coordinates(
				latitude: coordinate.latitude,
				longitude: coordinate.longitude
			)
			viewController?.renderCurrentLocation(renderCurrentLocation: model)
		}
	}

	func presentDistance(presentDistance: MainContactModel.Response) {
		if case .showDistance(let distance) = presentDistance {
			viewController?.renderDistance(renderDistance: distance)
		}
	}
}
