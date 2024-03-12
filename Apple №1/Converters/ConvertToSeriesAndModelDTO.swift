//
//  ConvertToSeriesAndModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 24.02.2024.
//

import Foundation

typealias RequestSeries = [MainRepairSeriesModel.ResponseSeries.Series]

/// Конвертор модели типа CatalogSeriesDTO в модель MainRepairSeriesModel.ResponseSeries.Series
/// Конвертируем в массив серий устройств, со списком моделей.
protocol IConvertToSeriesAndModelDTO: AnyObject {
	/**
	 Конвертирование модели вида CatalogSeriesDTO в в серию и модели устройств.
	 - Parameters:
			- device: Структура содержащая поля: ID устройства и название.
			- modelDTO: Конвертируемая модель.
	 - Returns: Возвращает структуру Series.
	 */
	func converterModel(device: MainRepairSeriesModel.RequestSeries.Devices, modelDTO: CatalogSeriesDTO) -> RequestSeries
}

final class ConvertToSeriesAndModelDTO: IConvertToSeriesAndModelDTO {
	func converterModel(device: MainRepairSeriesModel.RequestSeries.Devices, modelDTO: CatalogSeriesDTO) -> RequestSeries {
		searchDevice(device: device, model: modelDTO)
	}
}

private extension ConvertToSeriesAndModelDTO {
	// Выборка моделей для преданной категории.
	func searchDevice(device: MainRepairSeriesModel.RequestSeries.Devices, model: CatalogSeriesDTO) -> RequestSeries {
		let categories = model.ymlCatalog.shop.categories.category
		let series = categories.filter {
			if $0.parentID != nil && $0.parentID == String(device.deviceID) {
				return true
			}
			return false
		}
		var currentSeries: RequestSeries = []
		if let deviceLine = DeviceLines(rawValue: device.title) {
			switch deviceLine {
			case .phone:
				currentSeries = assemblySeriesPhone(entities: series)
			case .pad:
				currentSeries = assemblySeriesOtherDevice(deviceName: deviceLine, entities: series)
			case .watch:
				currentSeries = assemblySeriesOtherDevice(deviceName: deviceLine, entities: series)
			case .mac:
				currentSeries = assemblySeriesOtherDevice(deviceName: deviceLine, entities: series)
			case .macPro:
				currentSeries = assemblySeriesOtherDevice(deviceName: deviceLine, entities: series)
			case .macBook:
				currentSeries = assemblySeriesOtherDevice(deviceName: deviceLine, entities: series)
			case .pod:
				currentSeries = assemblySeriesOtherDevice(deviceName: deviceLine, entities: series)
			}
		}
		return currentSeries
	}

	// сборка массива серии и моделей для данной серии.
	func assemblySeriesPhone(entities: [CategoryDTO]) -> RequestSeries {
		var series: RequestSeries = []
		for element in PhoneSeries.allCases {
			var currentSeries = MainRepairSeriesModel.ResponseSeries.Series(title: element.rawValue, models: [])
			for entity in entities where entity.text.contains("\(element.rawValue)") {
				let parentID = entity.parentID ?? ""
				let model = MainRepairSeriesModel.ResponseSeries.Model(id: entity.id, parentID: parentID, title: entity.text)
				currentSeries.models.append(model)
			}
			series.append(currentSeries)
		}
		return series
	}

	func assemblySeriesOtherDevice(deviceName: DeviceLines, entities: [CategoryDTO]) -> RequestSeries {
		var series: RequestSeries = []
		var currentSeries = MainRepairSeriesModel.ResponseSeries.Series(title: deviceName.rawValue, models: [])
		for entity in entities where entity.text.contains("\(deviceName.rawValue)") {
			let parentID = entity.parentID ?? ""
			let model = MainRepairSeriesModel.ResponseSeries.Model(id: entity.id, parentID: parentID, title: entity.text)
			currentSeries.models.append(model)
		}
		series.append(currentSeries)
		return series
	}
}
