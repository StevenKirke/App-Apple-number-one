//
//  LoginWorker.swift
//  Apple №1
//
//  Created by Steven Kirke on 03.01.2024.
//

import Foundation

typealias ContactFromManager = Result<[ContactUser], Error>

protocol ISignInWorker: AnyObject {
	func signInVerification()
}

final class LoginWorker: ISignInWorker {

	// MARK: - Initializator
	internal init() { }

	func signInVerification() { }
}
