//
//  MainRepairSeriesModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 24.02.2024.
//

import Foundation

// swiftlint:disable nesting
/// Модель для отображения типов устройств.
enum MainRepairSeriesModel {
	/// Перечисление описывает запрос для получения серии и моделей для выбранного устройства.
	/// Модель описывающая устройства - MainRepairDevicesModel.
	enum RequestSeries {
		case success(Devices)

		struct Devices {
			/// ID типа устройства.
			var deviceID: Int
			/// Название типа.
			var parentID: Int
			/// Название типа.
			var title: String
		}
	}

	enum ResponseSeries {
		case success([Series])
		case failure(Error)

		struct Series: Decodable {
			var title: String
			/// Модели серий.
			var models: [Model]
		}
		struct Model: Decodable {
			/// ID.
			let id: String
			/// parent ID.
			let parentID: String
			/// Название серий.
			let title: String
		}
	}

	enum ViewModel {
		case success([Series])
		case failure(Error)

		struct Series: Decodable {
			var title: String
			/// Модели серий.
			var models: [Model]
		}
		struct Model: Decodable {
			/// ID.
			let id: String
			/// parent ID.
			let parentID: String
			/// Название текущего устройства.
			let title: String
		}
	}
}
// swiftlint:enable nesting

extension MainRepairSeriesModel.ViewModel.Series {
	init(from: MainRepairSeriesModel.ResponseSeries.Series) {
		let models = from.models.map { MainRepairSeriesModel.ViewModel.Model(from: $0) }
		self.init(title: from.title, models: models)
	}
}

extension MainRepairSeriesModel.ViewModel.Model {
	init(from: MainRepairSeriesModel.ResponseSeries.Model) {
		self.init(id: from.id, parentID: from.parentID, title: from.title)
	}
}
