//
//  ExtensionUIViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.01.2024.
//

import UIKit

extension UIViewController {
	/// Функция скрытия клавиатуры по нажатию 
	/// на любую область экрана.
	func hideKeyboard() {
		let tab = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tab.cancelsTouchesInView = false
		view.addGestureRecognizer(tab)
	}

	@objc private func dismissKeyboard() {
		view.endEditing(true)
	}
}
