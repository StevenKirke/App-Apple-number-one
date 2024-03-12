//
//  LoginPresenter.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import Foundation

protocol ILoginPresenter: AnyObject {
	///
	func present(response: LoginViewModel.ResponseCode)
	/// Метод открывающий ContactListViewController.
	func showContactList()
	/// Метод перехода на основное View.
	func showMainScene()
}

final class LoginPresenter {

	// MARK: - Dependencies
	private weak var viewController: ILoginInViewLogic?
	private var openContactListDelegate: IOpenContactListDelegate?
	private var handleSignInDelegate: ISignInCoordinator?

	// MARK: - Initializator
	internal init(
		openContactListDelegate: IOpenContactListDelegate?,
		viewController: ILoginInViewLogic?,
		handleSignInDelegate: ISignInCoordinator?
	) {
		self.openContactListDelegate = openContactListDelegate
		self.viewController = viewController
		self.handleSignInDelegate = handleSignInDelegate
	}
}

extension LoginPresenter: ILoginPresenter {
	func present(response: LoginViewModel.ResponseCode) {
		switch response {
		case .success(let code):
			let model = LoginViewModel.ViewModel.Code(code: "", checkCode: code.checkCode)
			viewController?.renderCode(model: model)
		case .failure(let error):
			viewController?.renderError()
			handleSignInDelegate?.showAlertScene(massage: error)
		}
	}

	func showContactList() {
		openContactListDelegate?.openContactScene { [weak self] phoneNumber in
			self?.viewController?.renderNumber(model: phoneNumber)
		}
	}

	func showMainScene() {
		handleSignInDelegate?.showMainScene()
	}
}
