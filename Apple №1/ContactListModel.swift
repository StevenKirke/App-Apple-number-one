//
//  ContactViewModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 03.01.2024.
//

import Foundation

/**
 Псевдоним перечисления ``ContactListModel.ViewModel.Phone``.
 Данный typealias предназначен для работы номером телефона.
 - Parameters:
   - phoneNumeric: 
		Номера телефона пользователя, числовые символы.
   - maskPhone: Номер телефона с маской.
 - Attention: 
		Маска номера может быть отличной от формата "+X (XXX) XXX-XX-XX".
*/
typealias PhoneNumberModel = ContactListModel.ViewModel.Phone

/**
 Псевдоним перечисления ``ContactListModel.ViewModel.Contact``.
 Данный typealias представляет собой структуру, описывающих контакт.
 - Parameters:
   - name: 
		Имя контакта.
   - phones: 
		Массив ``Phone``, номера телефонов пользователя, в числовых символах и с маской номера.
*/
typealias ContactListDisplay = ContactListModel.ViewModel.Contact

// swiftlint:disable nesting
/// Модель для работы ContactListScene
enum ContactListModel {
	/// Модель для полученных данных и передачи в Presenter.
	enum Response {
		/// Положительный ответ.
		/// Принимает массив ``Contact``.
		case success([Contact])
		/// Ошибка при получении данных.
		/// Тип Error.
		case failure(Error)
		/**
		 Структура описывающая полученные данные.
		 - Parameters:
		   - name: Имя контакта.
		   - phones: Массив номеров.
		*/
		struct Contact {
			var name: String
			var contacts: [String]
		}
	}
	/// Модель для отображения данных во ViewController.
	enum ViewModel {
		/// Положительный ответ.
		/// Передает массив ``Contact``.
		case success([Contact])
		/// Ошибка в получении данных.
		/// Тип Error, тип передаваемого значения String.
		case error(String)
		/**
		 Структура описывающая данные для View.
		 - Parameters:
		   - name: Имя контакта.
		   - phones: Массив номеров.
		*/
		struct Contact {
			var name: String
			var phones: [Phone]
		}
		/**
		 Структура номера телефона.
		 - Parameters:
		   - phoneNumeric: Номер телефона, числовые символы.
		   - maskPhone: Номер с маской.
		*/
		struct Phone {
			var phoneNumeric: String
			var maskPhone: String
		}
	}
}
// swiftlint:enable nesting

extension ContactListModel.Response.Contact {
	init(from: ContactUser) {
		self.init(name: from.fullName, contacts: from.phones)
	}
}

extension ContactListModel.ViewModel.Contact {
	init(
		from: ContactListModel.Response.Contact,
		masks: [PhoneNumberModel]
	) {
		self.init(name: from.name, phones: masks.map {
			PhoneNumberModel(phone: $0.phoneNumeric, maskPhone: $0.maskPhone)
		})
	}
}

extension ContactListModel.ViewModel.Phone {
	init(phone: String, maskPhone: String) {
		self.init(phoneNumeric: phone, maskPhone: maskPhone)
	}
}
