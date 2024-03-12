//
//  ContactListAssembler.swift
//  Apple №1
//
//  Created by Steven Kirke on 03.01.2024.
//

import UIKit

final class ContactListAssembler {
	/**
	 Сборщик сцены ContactList.
	- Parameters:
		 - handlerCloseContacts: Обработчик закрытия окна, списка контактов.
	*/
	func configurator(handlerCloseContacts: ICloseContactListDelegate) -> ContactListViewController {
		let contactManager = CNContactManager()
		let viewController = ContactListViewController()
		let phoneMaskManger = PhoneMaskService()
		let presenter = ContactListPresenter(
			phoneMaskManager: phoneMaskManger,
			closeContactListDelegate: handlerCloseContacts
		)
		let iterator = ContactListIterator(presenter: presenter, contactManager: contactManager)

		viewController.iterator = iterator
		presenter.viewController = viewController

		return viewController
	}
}
