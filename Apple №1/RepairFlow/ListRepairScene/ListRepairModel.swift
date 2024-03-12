//
//  ListRepairModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 25.02.2024.
//

import Foundation

// swiftlint:disable nesting
enum ListRepairModel {
	enum RequestListRepair {
		case success(Device)
		case failure(Error)

		struct Device {
			let deviceID: Int
			let parentID: Int
			let name: String
		}
	}

	enum ResponseDevices {
		case showRepairList([Repair])
		case showTitle(String)
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

	enum ViewModel {
		case showRepairList([Repair])
		case showTitle(String)

		struct Repair {
			let id: String
			let title: String
			let description: String
			let price: String
			let available: Bool
			var picture: String
		}
	}
}
// swiftlint:enable nesting

extension ListRepairModel.ViewModel.Repair {
	init(from: ListRepairModel.ResponseDevices.Repair) {
		self.init(id: from.id,
				  title: from.title,
				  description: from.description,
				  price: from.price,
				  available: from.available,
				  picture: from.picture
		)
	}
}
