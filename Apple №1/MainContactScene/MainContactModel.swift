//
//  MainContactModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import Foundation

// swiftlint:disable nesting
enum MainContactModel {
	enum Request {
		case showAddress(Int)
		case showCoordinate(Coordinates)

		struct Coordinates {
			let latitude: Double
			let longitude: Double
			var zoom: Float
			let flag: FlagCoordinates
		}

		struct FlagCoordinates {
			let latitude: Double
			let longitude: Double
		}
	}

	enum Response {
		case showAddress([AddressWorkShop])
		case showCurrentCoordinate(Coordinates)
		case showMap(Data)
		case failure(Error)

		struct AddressWorkShop {
			let title: String
			let address: String
			let coordinate: Coordinates
			let flag: FlagCoordinates
		}

		struct Coordinates {
			let latitude: Double
			let longitude: Double
		}
		struct FlagCoordinates {
			let latitude: Double
			let longitude: Double
		}
	}

	enum ViewModel {
		case showAddress(AddressWorkShop)
		case showMap(Data)

		struct AddressWorkShop {
			let title: String
			let address: String
			let coordinate: Coordinates
			let flag: FlagCoordinates
		}

		struct Coordinates {
			let latitude: Double
			let longitude: Double
		}
		struct FlagCoordinates {
			let latitude: Double
			let longitude: Double
		}
	}
}
// swiftlint:enable nesting

extension MainContactModel.ViewModel.AddressWorkShop {
	init(from: MainContactModel.Response.AddressWorkShop) {
		self.init(
			title: from.title,
			address: from.address,
			coordinate: MainContactModel.ViewModel.Coordinates(
				latitude: from.coordinate.latitude,
				longitude: from.coordinate.longitude),
			flag: MainContactModel.ViewModel.FlagCoordinates(
				latitude: from.flag.latitude,
				longitude: from.flag.longitude
			)
		)
	}
}
