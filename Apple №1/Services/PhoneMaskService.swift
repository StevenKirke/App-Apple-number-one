//
//  PhoneMaskService.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.01.2024.
//

import Foundation
/// Протокол создания маски номера телефона.
protocol IPhoneMaskService: AnyObject {
	/**
	 Метод обработки телефонного номера в формат +X (XXX) XXX-XX-XX.
	 - Parameters:
			- phoneNumber: Телефонный номер с текстовом формате.
	 - Returns: Возвращает два текстовых номера:
				1. Только числовые символы.
				2. Формат маски.
	 */
	func handlingPhone(phoneNumber: String) -> (String, String)
}

final class PhoneMaskService: IPhoneMaskService {

	private enum MaskPhone: String {
		/// Маска для мобильного телефона.
		case mobile = "+X (XXX) XXX-XX-XX"
		/// Маска для городского номера телефона.
		case landLine = "+XX XXXXXXXXXX"
	}

	func handlingPhone(phoneNumber: String) -> (String, String) {
		let filterNumber = filteringNumber(phoneNumber: phoneNumber)
		let cutNumber = checkLength(phoneNumber: filterNumber)
		let addMask = maskForNumber(phoneNumber: cutNumber)

		return (cutNumber, addMask)
	}

	/**
	 Проверка на числовые символы.
	 - Parameters: Телефонный номер с текстовом формате.
	 - Returns: Возвращает только числовые данные 0-9.
	 */
	private func filteringNumber(phoneNumber: String) -> String {
		let target = "[^0-9]"
		let result = phoneNumber.replacingOccurrences(of: target, with: "", options: .regularExpression)
		return result
	}

	/**
	 Проверка количество символов.
	 - Parameters:
			- phoneNumber: Телефонный номер с текстовом формате.
	 - Returns: Возвращает только то количество символов, которое указано в maxCount.
	 - Note: maxCount по умолчанию 11.
	 */
	private func checkLength(phoneNumber: String) -> String {
		var currentPhone = ""
		let maxCount: Int = 10
		if currentPhone.count <= maxCount {
			currentPhone = String(phoneNumber.prefix(maxCount))
		}
		if currentPhone.count > maxCount {
			currentPhone.removeLast()
		}
		return currentPhone
	}

	/**
	 Метод добавления маски на номер телефона.
	 - Parameters:
			- phoneNumber: Телефонный номер с текстовом формате.
	 - Returns: Возвращает маску для мобильного и городского номера телефона,
				формата +X (XXX) XXX-XX-XX и +XX XXXXXXXXXX.
	 - Note: Обрабатывает номера телефонов, с количеством символов от 10 до 13.
	 */
	private func maskForNumber(phoneNumber: String) -> String {
		var currentPhone = ""
		switch phoneNumber.count {
		case 1...10:
			let assembly = "7" + phoneNumber
				currentPhone = formatMaskPhone(phone: assembly, mask: .mobile)
		case 11:
			currentPhone = formatMaskPhone(phone: phoneNumber, mask: .mobile)
		case 13:
			currentPhone = formatMaskPhone(phone: phoneNumber, mask: .mobile)
		default:
			currentPhone = ""
		}
		return currentPhone
	}

	/**
	 Метод обработки номера телефона в формат +X (XXX) XXX-XX-XX и +XX XXXXXXXXXX.
	 - Parameters:
			- phoneNumber: Телефонный номер с текстовом формате.
			- mask: Выбор необходимой маски, мобильный или городской номер.
	 - Returns: Возвращает маску для мобильного и городского номера телефона.
	 */
	private func formatMaskPhone(phone: String, mask: MaskPhone) -> String {
		let currentMask = mask.rawValue
		var result = ""
		var index = phone.startIndex

		for element in currentMask where index < phone.endIndex {
			if element == "X" {
				result.append(phone[index])
				index = phone.index(after: index)
			} else {
				result.append(element)
			}
		}
		return result
	}
}
