//
//  OrderRepairModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 05.03.2024.
//

import Foundation

// swiftlint:disable nesting
enum OrderRepairModel {
	enum RequestOrderRepair {
		case showTitleDevice(String)
		case showRepairDescription(Repair)
		case failure(Error)

		struct Repair {
			let id: String
			let title: String
			let description: String
			let price: String
			let available: Bool
			var picture: String
		}
	}

	enum ResponseRepair {
		case showDeviceTitle(String)
		case showRepairDescription(Repair)
		case showImage(Data)
		case failure(Error)

		struct Repair {
			let id: String
			let title: String
			let description: String
			let price: String
			let available: Bool
		}
	}

	enum ViewModel {
		case showRepairDescriptionModel(Repair)
		case showImageModel(Data)
		case showTitle(String)

		struct Repair {
			let title: String
			let description: String
			let price: String
			let available: Bool
		}
	}
}
// swiftlint:enable nesting

extension OrderRepairModel.ResponseRepair.Repair {
	init(from: OrderRepairModel.RequestOrderRepair.Repair) {
		self.init(
			id: from.id,
			title: from.title,
			description: from.description,
			price: from.price,
			available: from.available
		)
	}
}

extension OrderRepairModel.ViewModel.Repair {
	init(from: OrderRepairModel.ResponseRepair.Repair) {
		self.init(
			  title: from.title,
			  description: from.description,
			  price: Self.addTextInPrice(price: from.price),
			  available: from.available
		)
	}

	private static func addTextInPrice(price: String) -> String {
		"от \(price) руб."
	}
}
