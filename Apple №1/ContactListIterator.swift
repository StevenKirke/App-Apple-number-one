//
//  ContactListIterator.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.01.2024.
//

import Foundation

typealias ResponceCL = ContactListModel.Response

protocol IContactListIterator: AnyObject {
	/// Запрос к списку контактов.
	/// - Important: Данная функция работает async.
	func fetchContact() async
	/// Закрытие окна контакты, с сохранением телефонного номера.
	/// - Parameters:
	/// 	- number: Принимает модель Phone представляющую структуру.
	func handleContact(number: PhoneNumberModel)
}

final class ContactListIterator {

	// MARK: - Dependencies
	var presenter: IContactListPresenter?
	private let contactManager: ICNContactManager?

	// MARK: - Initializator
	internal init(
		presenter: IContactListPresenter?,
		contactManager: ICNContactManager?
	) {
		self.presenter = presenter
		self.contactManager = contactManager
	}
}

extension ContactListIterator: IContactListIterator {
	func fetchContact() async {
		await contactManager?.fetchContacts { result in
			switch result {
			case .success(let contacts):
				let result = contacts.map {
					ContactListModel.Response.Contact(from: $0)
				}
				presenter?.present(response: .success(result))
			case .failure(let error):
				presenter?.present(response: .failure(error))
			}
		}
	}

	func handleContact(number: PhoneNumberModel) {
		presenter?.handleContact(number: number)
	}
}
