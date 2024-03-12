//
//  LoginAssembler.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import UIKit

final class LoginAssembler {
	func configurator(
		openContactListDelegate: IOpenContactListDelegate?,
		handleSignInDelegate: ISignInCoordinator?
	) -> LoginViewController {
		let phoneMaskService = PhoneMaskService()
		let codeGenerator = CodeGenerateService()
		let viewController = LoginViewController(phoneMaskService: phoneMaskService)
		let presenter = LoginPresenter(
			openContactListDelegate: openContactListDelegate,
			viewController: viewController,
			handleSignInDelegate: handleSignInDelegate)
		let iterator = LoginIterator(presenter: presenter, codeGenerator: codeGenerator)

		viewController.iterator = iterator

		return viewController
	}
}
