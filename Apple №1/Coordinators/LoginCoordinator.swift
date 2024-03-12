//
//  LoginCoordinator.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import UIKit

protocol ISignInCoordinator: ICoordinator {
	/// Запуск экрана регистрации пользователя.
	func showSignInScene()
	/// Запуск экрана списка контактов.
	func showContactScene()
	/// Запуск основного экрана, TabBarController.
	func showMainScene()
	/// Запуск экрана предупреждения, UIAlert.
	func showAlertScene(massage: String)
}

protocol ICloseContactListDelegate: AnyObject {
	/// Закрытие окна списка контактов из адресной книги.
	/// - Parameters:
	///   - number: Опциональный тип, модели телефона.
	func closeContactScene(number: PhoneNumberModel)
	/// Запуск экрана предупреждения, UIAlert.
	func showAlertScene(massage: String)
}

protocol IOpenContactListDelegate: AnyObject {
	func openContactScene(callback: ((PhoneModelForLoginView) -> Void)?)
}

final class LoginCoordinator: ISignInCoordinator {

	// MARK: - Public properties
	var childCoordinators: [ICoordinator] = []

	// MARK: - Internal properties
	var finishFlow: (() -> Void)?

	// MARK: - Dependencies
	var navigationController: UINavigationController

	// MARK: - Private properties
	private var  closeContactCallback: ((PhoneModelForLoginView) -> Void)?

	// MARK: - Initializator
	internal init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Public methods
	func start() {
		// showSignInScene()
		// MARK: - Отключаем экран логина.
		self.finishFlow?()
	}

	func showSignInScene() {
		let assembly = LoginAssembler()
		let singInVC = assembly.configurator(openContactListDelegate: self, handleSignInDelegate: self)
		navigationController.pushViewController(singInVC, animated: true)
	}

	func showContactScene() {
		let assembly = ContactListAssembler()
		let contactListVC = assembly.configurator(handlerCloseContacts: self)
		navigationController.pushViewController(contactListVC, animated: true)
	}

	func showMainScene() {
		self.finishFlow?()
	}

	func showAlertScene(massage: String) {
		show(typeMassage: .errorBlock(massage: massage))
	}
}

extension LoginCoordinator: IOpenContactListDelegate {
	func openContactScene(callback: ((PhoneModelForLoginView) -> Void)?) {
		closeContactCallback = callback
		showContactScene()
	}
}

// MARK: - Add protocol ICloseContactListDelegate.
extension LoginCoordinator: ICloseContactListDelegate {
	func closeContactScene(number: PhoneNumberModel) {
		let model = PhoneModelForLoginView(from: number)
		closeContactCallback?(model)
		closeContactCallback = nil
		navigationController.popViewController(animated: true)
	}

	func failure(massage: String) {
		show(typeMassage: .errorBlock(massage: massage))
	}
}

// MARK: - Add protocol ICustomUIAlertProtocol.
extension LoginCoordinator: ICustomUIAlertProtocol {
	func show(typeMassage: AlertMassageType) {
		let alertVC = CustomUIAlertController()
		alertVC.show(typeMassage: typeMassage)
		navigationController.present(alertVC, animated: true)
	}
}
