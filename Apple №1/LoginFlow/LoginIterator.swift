//
//  LoginIterator.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import Foundation

protocol ILoginInIterator: AnyObject {
	/// Отображение списка контактов.
	func showContactList()
	/// Запрос кода на подтверждение регистрации.
	func fetchCode()
	/// Метод перехода на основное View.
	func showMainScene()
}

final class LoginIterator {

	// MARK: - Dependencies
	var presenter: ILoginPresenter?
	var codeGenerator: ICodeGenerateService

	// MARK: - Private properties

	// MARK: - Initializator
	internal init(
		presenter: ILoginPresenter?,
		codeGenerator: ICodeGenerateService
	) {
		self.presenter = presenter
		self.codeGenerator = codeGenerator
	}
}

extension LoginIterator: ILoginInIterator {
	func showContactList() {
		presenter?.showContactList()
	}

	func fetchCode() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			let code = self.codeGenerator.code
			print("code \(code)")
			let response = LoginViewModel.ResponseCode.Code(checkCode: code)
			self.presenter?.present(response: .success(response))
			// self.presenter?.present(response: .failure("Error request code."))
		}
	}

	func showMainScene() {
		presenter?.showMainScene()
	}
}
