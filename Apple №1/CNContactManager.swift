//
//  CNContactManager.swift
//  Apple №1
//
//  Created by Steven Kirke on 03.01.2024.
//

import Contacts

/// Перечисление возвращаемых значений из контактного справочника телефона.
///
/// - Parameters:
///   - success: Возвращает массив ``ContactUser``
///   при положительном результате
///   - failure: Возвращает ошибку невозможности обработать справочник.
enum Contacts {
	case success([ContactUser])
	case failure(ErrorCNContact)
}

// Перечисление ошибок CNContact
enum ErrorCNContact: LocalizedError {
	case errorHandling(Error)

	var errorDescription: String? {
		var text = ""
		switch self {
		case .errorHandling(let error):
			text = "Не возможно обработать контакты: \(error)"
		}
		return text
	}
}

/// Структура описывающая контакт телефонного справочника.
/// - Parameters:
///   - fullName: Конкатенация из строк имени и фамилии.
///   - phones: Массив необработанных номеров
struct ContactUser {
	let fullName: String
	let phones: [String]
}

protocol ICNContactManager: AnyObject {
	/// Получение списка контактов
	/// - Returns: Возвращаем структуру ``LoginViewModel.ResponceContact``
	/// - Note: Метод необходимо реализовывать как async,
	/// так как идет запрос к телефонному справочнику пользователя
	func fetchContacts(result: (Contacts) -> Void) async
}

final class CNContactManager: ICNContactManager {

	// MARK: - Public methods
	/// Получение списка контактов через запрос к справочнику телефона.
	/// - Returns: Возвращаем структуру ``LoginViewModel.ResponceContact``
	/// В случае успешного запроса, получаем массив контактов,
	/// в альтернативном - ошибку невозможности обработки.
	func fetchContacts(result: (Contacts) -> Void) async {
		var contactList: [ContactUser] = []
		let store = CNContactStore()
		let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
		let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
		do {
			try store.enumerateContacts(with: fetchRequest) { contact, _ in
				let mobile = mobilePhone(contacts: contact)
				if !mobile.isEmpty {
					let fullName = "\(contact.givenName)  \(contact.familyName)"
					contactList.append(ContactUser(fullName: fullName, phones: mobile))
				}
			}
		} catch let error {
			result(.failure(.errorHandling(error)))
		}
		result(.success(contactList))
	}

	/// Перебор телефонных номеров
	/// - Parameters:
	///   - contacts: Массив телефонных номеров текущего контакта
	/// - Returns: [String] Возвращаем список номеров текущего контакта
	private func mobilePhone(contacts: CNContact) -> [String] {
		var currentNumber: [String] = []
		for number in contacts.phoneNumbers {
			currentNumber.append(number.value.stringValue)
		}
		return currentNumber
	}
}
