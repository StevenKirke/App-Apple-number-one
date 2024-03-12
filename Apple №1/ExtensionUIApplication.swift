//
//  ExtensionUIApplication.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.01.2024.
//

import UIKit

extension UIApplication {
	/**
	 Метод скрытия клавиатуры, когда пользователь закончил символьный ввод UITextField.
	 */
	func endEditing() {
		sendAction(
			#selector(UIResponder.resignFirstResponder),
			to: nil,
			from: nil,
			for: nil
		)
	}
}

extension UIApplication {
	/**
	 Метод отображения текущей версии и билда приложения.
	 */
	func versionAndBuild() -> String {
		let version = self.applicationVersion()
		let build = self.applicationBuild()
		return "\(version) \(build)"
	}
	/**
	 Метод отображения текущей версии приложения.
	 */
	private func applicationVersion() -> String {
		let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		if let currentVersion = version {
			return currentVersion
		}
		return ""
	}
	/**
	Метод отображения текущего билда приложения.
	*/
	private func applicationBuild() -> String {
		let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
		if let currentBuild = build {
			return currentBuild
		}
		return ""
	}
}
