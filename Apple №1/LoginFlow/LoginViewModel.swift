//
//  LoginViewModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import Foundation
/**
 Псевдоним перечисления, ``LoginViewModel.ViewModel.Phone``, передачи данных для визуализации во View.
 - Parameters:
   - name: Имя контакта.
   - phones: Массив Phone.
*/
typealias PhoneModelForLoginView = LoginViewModel.ViewModel.Phone

/**
 Псевдоним перечисления, ``LoginViewModel.ViewModel.CodeString``, передачи данных для визуализации во View.
 - Parameters:
   - code: Проверочный код.
   - checkCode: Код.
*/
typealias CodeModelForLoginView = LoginViewModel.ViewModel.Code

// swiftlint:disable nesting
enum LoginViewModel {
	struct Responce {
		let phone: String
		let code: Int
	}

	enum ResponseCode {
		case success(Code)
		case failure(String)

		struct Code {
			let checkCode: String
		}
	}

	enum ResponseContact {
		case success([Contact])
		case failure(Error)

		struct Contact: Decodable {
			let fullName: String
			let phones: [String]
		}
	}

	enum ViewModel {
		case correctCode(Code)
		case contact(Phone)
		case failure(String)

		struct Code {
			var code: String
			var checkCode: String
		}

		struct Phone {
			var phoneNumeric: String
			var maskPhone: String
		}
	}
}
// swiftlint:enable nesting

extension PhoneModelForLoginView {
	init(from: PhoneNumberModel) {
		self.init(phoneNumeric: from.phoneNumeric, maskPhone: from.maskPhone)
	}
}

extension LoginViewModel.ViewModel.Code {
	init(from: LoginViewModel.ResponseCode.Code) {
		self.init(code: "", checkCode: from.checkCode)
	}
}
