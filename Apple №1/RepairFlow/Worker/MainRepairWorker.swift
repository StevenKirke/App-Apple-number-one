//
//  MainRepairWorker.swift
//  Apple №1
//
//  Created by Steven Kirke on 24.01.2024.
//

import Foundation

/// Псевдоним возврата модели, содержит массив типов устройств, или ошибку.
typealias ResultDevices = (Result<[MainRepairDevicesModel.ResponseDevices.Device], Error>) -> Void?

/// Псевдоним возврата модели, содержит массив серии девайсов и списки моделей, или ошибку.
typealias ResultSeries = (Result<[MainRepairSeriesModel.ResponseSeries.Series], Error>) -> Void?

protocol IMainRepairWorker: AnyObject {
	/// Метод получения списка моделей и неисправностей.
	func getDataDevices(result: @escaping ResultDevices)

	/// Метод получения серии и модельного ряда.
	func getDataSeriesAndModel(device: MainRepairSeriesModel.RequestSeries.Devices, result: @escaping ResultSeries)
}

final class MainRepairWorker: IMainRepairWorker {

	// MARK: - Public properties
	// Файл с данными.
	private let fileName = "ModelsAndRepair"

	// MARK: - Dependencies
	let fileManager: ILoadFileManager
	let decodeJSONManager: IDecodeJsonManager
	let convertorDevices: IConvertorDevicesDTO
	let convertorSeries: IConvertToSeriesAndModelDTO

	// MARK: - Initializator
	internal init(
		fileManager: ILoadFileManager,
		decodeJSONManager: IDecodeJsonManager,
		convertorDevices: IConvertorDevicesDTO,
		convertorSeries: IConvertToSeriesAndModelDTO
	) {
		self.fileManager = fileManager
		self.decodeJSONManager = decodeJSONManager
		self.convertorDevices = convertorDevices
		self.convertorSeries = convertorSeries
	}

	// MARK: - Private methods
	// Запрос на список устройств.
	func getDataDevices(result: @escaping ResultDevices) {
		fileManager.getFile(resource: fileName, type: .json, response: { data in
			switch data {
			case .success(let currentData):
				self.decode(data: currentData, model: CatalogSeriesDTO.self) { resultDecode in
					switch resultDecode {
					case .success(let json):
						let listDevices = json.ymlCatalog.shop.categories.category
						let categories = self.convertorDevices.converterModel(requestDevices: listDevices)
						result(.success(categories))
					case .failure(let error):
						result(.failure(error))
					}
				}
			case .failure(let error):
					result(.failure(error))
			}
		})
	}
	// Запрос на список серий и моделей для запрашиваемого типа устройства.
	func getDataSeriesAndModel(device: MainRepairSeriesModel.RequestSeries.Devices, result: @escaping ResultSeries) {
		fileManager.getFile(resource: fileName, type: .json) { resultData in
			switch resultData {
			case .success(let data):
				self.decode(data: data, model: CatalogSeriesDTO.self) { json in
					switch json {
					case .success(let json):
						let convert = self.convertorSeries.converterModel(device: device, modelDTO: json)
						result(.success(convert))
					case .failure(let error):
						result(.failure(error))
					}
				}
			case .failure(let error):
				result(.failure(error))
			}
		}
	}
}

// MARK: - Decode JSON
private extension MainRepairWorker {
	// Декодирование модели CatalogDTO.
	func decode<T: Decodable>(data: Data, model: T.Type, resultJSON: @escaping (Result<T, DecodeError>) -> Void) {
		decodeJSONManager.decodeJSON(data: data, model: model, returnJSON: { json in
			switch json {
			case .success(let currentJSON):
				resultJSON(.success(currentJSON))
			case .failure(let error):
				resultJSON(.failure(error))
			}
		})
	}
}
