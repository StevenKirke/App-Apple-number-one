//
//  ConvertorDeviceTitle.swift
//  Apple №1
//
//  Created by Steven Kirke on 23.02.2024.
//

import Foundation

/// Тип для конвертации модели типа DTO в тип MainRepairDevicesModel.ResponseDevices.Device.
typealias DevicesResponse = MainRepairDevicesModel.ResponseDevices.Device

protocol IConvertorDevicesDTO: AnyObject {
	/// Конвертор модели типа CategoriesDTO в модель MainRepairDevicesModel.ResponseDevices.Device.
	/// Преобразование title устройств, добавление изображения, удаление лишних элементов из модели.
	/// - Parameters:
	///     - requestDevices: Модель CatalogSeriesDTO.YmlCatalogDTO.shop.categories.category
	/// - Returns: Возвращает массив MainRepairDevicesModel.ResponseDevices.Device.
	func converterModel(requestDevices: [CategoryDTO]) -> [DevicesResponse]
}

final class ConvertorDevicesDTO: IConvertorDevicesDTO {
	// Список устройств.
	private enum DeviceLinesTest: String, CaseIterable {
		case phone = "iPhone"
		case pad = "iPad"
		case watch = "Watch"
		case mac = "iMac"
		case macPro = "Mac Pro"
		case macBook = "MacBook"
		case pod = "iPod"
		// Изображения для каждого устройства.
		var image: String {
			var imageName = "IconDevices/"
			switch self {
			case .phone:
				imageName += "iPhone"
			case .pad:
				imageName += "iPad"
			case .watch:
				imageName += "iWatch"
			case .mac:
				imageName += "iMac"
			case .macPro:
				imageName += "MacPro"
			case .macBook:
				imageName += "MacBook"
			case .pod:
				imageName += "iPod"
			}
			return imageName
		}
	}

	func converterModel(requestDevices: [CategoryDTO]) -> [DevicesResponse] {
		self.calculateDevice(devices: requestDevices)
	}
}

private extension ConvertorDevicesDTO {
	func calculateDevice(devices: [CategoryDTO]) -> [DevicesResponse] {
		var convert: [DevicesResponse] = []
		if let parentCategory = devices.first(where: { $0.parentID == nil }) {
			for device in devices where
			device.parentID == parentCategory.id && device.text.lowercased().contains("ремонт".lowercased()) {
			let trimRussian = removeCharsFromText(text: device.text)
			let trimOtherLatter = removeWord(text: trimRussian)
			let searchImage = selectionImage(name: trimOtherLatter)
			convert.append(DevicesResponse(
				id: device.id,
				title: trimOtherLatter,
				imageName: searchImage
			))
		   }
		}
		return convert
	}

	// Удаление из текста всех кириллических символов.
	private func removeCharsFromText(text: String) -> String {
		let pattern = "[А-Яа-я]"
		let replace = text.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
		let trim = replace.trimmingCharacters(in: .whitespaces)
		return trim
	}

	// Удаление из названия слова "Apple".
	private func removeWord(text: String) -> String {
		let remove = text.replacingOccurrences(of: "Apple", with: "")
		let trim = remove.trimmingCharacters(in: .whitespaces)
		return trim
	}
	// Поиск изображения для устройства.
	// В случае отрицательного результата, возвращаем изображение пустышку.
	private func selectionImage(name: String) -> String {
		for device in DeviceLinesTest.allCases where device.rawValue == name {
			return device.image
		}
		return "IconDevices/emptyImageDevices"
	}
}
