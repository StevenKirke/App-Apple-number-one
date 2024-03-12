//
//  ContactListPresenter.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.01.2024.
//

import Foundation

protocol IContactListPresenter: AnyObject {
	/// Метод обработки данных в Iterator в Presenter.
	/// - Parameters: авв
	///		- response: Параметр представляет собой ``ContactListModel.RequestTest``
	///	- Throws:
	func present(response: ContactListModel.Response)
	/// Метод закрывающий сцену контактов.
	/// - Parameters:
	///   - number: Принимает модель для вывода данных на экран ``SignInViewController``.
	func handleContact(number: PhoneNumberModel)
}

final class ContactListPresenter {

	// MARK: - Dependencies
	weak var viewController: IContactListViewLogic?
	private var phoneMaskManager: IPhoneMaskService?

	/// Обработчик закрытия окна, список контактов.
	var closeContactListDelegate: ICloseContactListDelegate?

	// MARK: - Initializator
	internal init(
		phoneMaskManager: IPhoneMaskService?,
		closeContactListDelegate: ICloseContactListDelegate?
	) {
		self.phoneMaskManager = phoneMaskManager
		self.closeContactListDelegate = closeContactListDelegate
	}
}

extension ContactListPresenter: IContactListPresenter {
	func present(response: ContactListModel.Response) {
		switch response {
		case .success(let contacts):
			let viewModel = contacts.map {
				let currentContact = addMaskPhone(phones: $0.contacts)
				return ContactListDisplay(from: $0, masks: currentContact)
			}
			viewController?.render(contactList: viewModel)
		case .failure(let error):
			closeContactListDelegate?.showAlertScene(massage: error.localizedDescription)
		}
	}

	func handleContact(number: PhoneNumberModel) {
		closeContactListDelegate?.closeContactScene(number: number)
	}
}

private extension ContactListPresenter {
	func addMaskPhone(phones: [String]) -> [PhoneNumberModel] {
		var numbersWithMask: [PhoneNumberModel] = []
		if let phoneManager = phoneMaskManager {
			numbersWithMask = phones.map { phone in
				let maskNumber = phoneManager.handlingPhone(phoneNumber: phone)
				return PhoneNumberModel(phone: maskNumber.0, maskPhone: maskNumber.1)
			}
		}
		return numbersWithMask
	}
}
