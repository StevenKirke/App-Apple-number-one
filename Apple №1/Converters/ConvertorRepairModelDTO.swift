//
//  ConvertorRepairModelDTO.swift
//  Apple №1
//
//  Created by Steven Kirke on 03.03.2024.
//

import Foundation

/// Псевдоним для устройства.
typealias RLDevice = ListRepairModel.RequestListRepair.Device

/// Тип для конвертации модели типа DTO в тип ListRepairViewModel.ResponseDevices.Repair.
typealias RLResponse = ListRepairModel.ResponseDevices.Repair

protocol IConvertorRepairModelDTO: AnyObject {
	/// Конвертор модели типа ListRepairDTO в модель ListRepairViewModel.ResponseDevices.Repair.
	/// Преобразование title устройств, добавление изображения, удаление лишних элементов из модели.
	/// - Parameters:
	///     - requestDevices: Модель CatalogSeriesDTO.YmlCatalogDTO.shop.offers.offer
	/// - Returns: Возвращает массив ListRepairViewModel.ResponseDevices.Repair.
	func converterRepair(modelDevice: RLDevice, modelDTO: [ListRepairOfferDTO]) -> [RLResponse]
}

final class ConvertorRepairModelDTO: IConvertorRepairModelDTO {
	func converterRepair(modelDevice: RLDevice, modelDTO: [ListRepairOfferDTO]) -> [RLResponse] {
		self.converter(modelDevice: modelDevice, modelDTO: modelDTO)
	}
}

private extension ConvertorRepairModelDTO {
	func converter(modelDevice: RLDevice, modelDTO: [ListRepairOfferDTO]) -> [RLResponse] {
		var repairList: [RLResponse] = []
		for repair in modelDTO {
			let search = self.searchRepair(deviceID: modelDevice.deviceID, categories: repair.categoryID.array)
			if search {
				let repair = ListRepairModel.ResponseDevices.Repair(
					id: repair.id,
					title: repair.name,
					description: repair.description.title,
					price: repair.price,
					available: convertAvailable(available: repair.available),
					picture: repair.picture ?? "")
				repairList.append(repair)
			}
		}
		return repairList
	}

	func searchRepair(deviceID: Int, categories: [Int]) -> Bool {
		for category in categories where category == deviceID {
			return true
		}
		return false
	}

	func convertAvailable(available: String) -> Bool {
		available == "true" ? true : false
	}
}
