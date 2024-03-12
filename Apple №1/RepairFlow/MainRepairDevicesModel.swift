//
//  MainRepairDevicesModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 22.02.2024.
//

import Foundation

// swiftlint:disable nesting
/// Модель для отображения типов устройств.
enum MainRepairDevicesModel {
	enum RequestDevices {
		case success
		case failure(Error)
	}

	enum ResponseDevices {
		case success([Device])
		case failure(Error)

		struct Device {
			/// ID.
			let id: String
			/// Название устройства.
			let title: String
			/// Изображение.
			var imageName: String
		}
	}

	enum ViewModel {
		case success([Device])
		case failure(Error)

		struct Device {
			/// ID.
			let id: Int
			/// Название устройства.
			let title: String
			/// Изображение.
			let imageName: String
		}
	}
}
// swiftlint:enable nesting

extension MainRepairDevicesModel.ViewModel.Device {
	init(from: MainRepairDevicesModel.ResponseDevices.Device) {
		let id = Int(from.id) ?? 0
		self.init(id: id, title: from.title, imageName: from.imageName)
	}
}
