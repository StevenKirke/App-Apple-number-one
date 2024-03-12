//
//  CodeGenerateService.swift
//  Apple №1
//
//  Created by Steven Kirke on 15.01.2024.
//

import Foundation

protocol ICodeGenerateService: AnyObject {
	var code: String { get set }

}

final class CodeGenerateService: ICodeGenerateService {

	// MARK: - Public properties
	var code: String = ""

	// MARK: - Initializator
	internal init(code: String = "") {
		self.code = genericCode()
	}

	// MARK: - Private properties
	private let digits: UInt8 = 4

	// MARK: - Private methods
	private func genericCode() -> String {
		code =  ""
		for _ in 1...digits {
			let random = Int.random(in: 0...9)
			code += String(random)
		}
		return code
	}
}
