//
//  ListRepairWorker.swift
//  Apple №1
//
//  Created by Steven Kirke on 26.02.2024.
//

import Foundation

/// Псевдоним возврата модели, содержит массив неисправностей для выбранного устройства, или ошибку.
typealias ResultRepairs = (Result<[ListRepairModel.ResponseDevices.Repair], Error>) -> Void?

protocol IListRepairWorker: AnyObject {
	/// Метод получения списка неисправностей для текущей модели устройства.
	/// - Parameters:
	///     - device: Текущая модель устройства. Имя, ID.
	/// - Returns: список неисправностей или ошибку.
	func getRepairList(device: ListRepairModel.RequestListRepair.Device, repairList: @escaping ResultRepairs)

}

final class ListRepairWorker: IListRepairWorker {
	// MARK: - Public properties
	// Файл с данными.
	private let fileName = "ModelsAndRepair"

	// MARK: - Dependencies
	let fileManager: ILoadFileManager
	let decodeJSONManager: IDecodeJsonManager
	let convertorDTO: IConvertorRepairModelDTO

	init(fileManager: ILoadFileManager, decodeJSONManager: IDecodeJsonManager, convertorDTO: IConvertorRepairModelDTO) {
		self.fileManager = fileManager
		self.decodeJSONManager = decodeJSONManager
		self.convertorDTO = convertorDTO
	}

	func getRepairList(device: ListRepairModel.RequestListRepair.Device, repairList: @escaping ResultRepairs) {
		fileManager.getFile(resource: fileName, type: .json) { resultData in
			switch resultData {
			case .success(let data):
				self.decode(data: data, model: ListRepairDTO.self) { resultJSON in
					switch resultJSON {
					case .success(let json):
						let listRepairs = json.ymlCatalog.shop.offers.offer
							let convert = self.convertorDTO.converterRepair(modelDevice: device, modelDTO: listRepairs)
							repairList(.success(convert))
					case .failure(let error):
						repairList(.failure(error))
					}
				}
			case .failure(let error):
				repairList(.failure(error))
			}
		}
	}
}

// MARK: - Decode JSON
private extension ListRepairWorker {
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
