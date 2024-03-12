//
//  CustomColors.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import UIKit

protocol IAddColorAssets {
	/// Добавление цвета из Assets
	/// - Parameters:
	///   - name: ``AssetsColor``
	/// - Returns: UIColor?
	static func addColor(_ name: AssetsColor) -> UIColor?
}

/// Список цветов.
enum AssetsColor: String {
	/// color424342 серый
	case color424342
	///  colorD9D9D9 светло-серый
	case colorD9D9D9
	///  color097CFB синий
	case color097CFB
	///  colorE94135 красный
	case colorE94135
	///  colorEAEAEA бело-серый
	case colorEAEAEA
	///  colorEAEAEA бело-светло-серый
	case colorC4C4C4
}

private extension AssetsColor {
	var patch: String {
		"CustomColors/\(rawValue)"
	}
}
/// - Parameters: Блок описывающий параметры.
///   - first: Первый аргумент метода.
///   - second: Второй аргумент метода.
///
extension UIColor: IAddColorAssets {
	/// Добавление цвета из Assets
	/// - Parameters:
	///   - name: Параметр enum из ``AssetsColor``
	/// - Returns: UIColor?
	static func addColor(_ name: AssetsColor) -> UIColor? {
		UIColor(named: name.patch)
	}
}
