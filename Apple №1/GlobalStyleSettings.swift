//
//  GlobalStyleSettings.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.01.2024.
//

import Foundation

protocol IGlobalStyle {
	var radius: CGFloat { get }
}

typealias Styles = GlobalStyleSettings

/// Стили для UI элементов
/// Note: Настройки радиусов, размеров шрифтов, отступов, прозрачности, длительности анимацтт.
enum GlobalStyleSettings {
	/// Настройки радиусов.
	enum Radius {
		/// 1
		static let radiusOne: CGFloat = 1
		/// 7
		static let radiusTextField: CGFloat = 7
	}

	/// Настройки ширины границы.
	enum Border {
		/// 1
		static let one: CGFloat = 1
	}

	/// Настройки размеров текста
	enum Fonts {
		/// 12
		static let little: CGFloat = 12
		/// 14
		static let small: CGFloat = 14
		/// 16
		static let average: CGFloat = 16
		/// 18
		static let big: CGFloat = 18
		/// 20
		static let bigger: CGFloat = 20
		/// 30
		static let huge: CGFloat = 30
		/// 44
		static let fortyFour: CGFloat = 44
	}

	/// Множитель
	enum Multiplay {
		/// 0
		static let zero: CGFloat = 0
		/// 0.5
		static let fiveTenths: CGFloat = 0.5
	}

	/// Настройки высоты
	enum Heights {
		/// 0
		static let zero: CGFloat = 0
		/// 2
		static let two: CGFloat = 2
		/// 3
		static let three: CGFloat = 3
		/// 4
		static let four: CGFloat = 4
		/// 5
		static let five: CGFloat = 5
		/// 6
		static let six: CGFloat = 6
		/// 10
		static let teen: CGFloat = 10
		/// 14
		static let fourteen: CGFloat = 14
		/// 15
		static let fifteen: CGFloat = 15
		/// 20
		static let twenty: CGFloat = 20
		/// 25
		static let twentyFive: CGFloat = 25
		/// 30
		static let thirty: CGFloat = 30
		/// 33
		static let thirtyThree: CGFloat = 33
		/// 35
		static let thirtyFive: CGFloat = 35
		/// 40
		static let fourth: CGFloat = 40
		/// 45
		static let fortyFive: CGFloat = 45
		/// 60
		static let sixty: CGFloat = 60
		/// 80
		static let eighty: CGFloat = 80
		/// 300
		static let threeHundred: CGFloat = 300
		/// 182
		static let oneHundredEightyTwo: CGFloat = 182
	}

	/// Настройки отступов
	enum Padding {
		/// 0
		static let zero: CGFloat = 0
		/// 5
		static let little: CGFloat = 5
		/// 10
		static let small: CGFloat = 10
		/// 20
		static let average: CGFloat = 20
		/// 30
		static let big: CGFloat = 30
		/// 32
		static let bigLittle: CGFloat = 32
		/// 40
		static let bigger: CGFloat = 40
	}

	/// Настройки альфа канала
	enum Alpha {
		/// 0
		static let zero: CGFloat = 0
		/// 0.1
		static let oneTenth: CGFloat = 0.1
		/// 0.2
		static let twoTenths: CGFloat = 0.2
		/// 0.3
		static let threeTenths: CGFloat = 0.3
		/// 0.4
		static let fourTenths: CGFloat = 0.4
		/// 0.5
		static let fiveTenths: CGFloat = 0.5
	}

	enum ZPosition {
		/// 10
		static let ten: CGFloat = 10
		/// 11
		static let eleven: CGFloat = 11
		/// 12
		static let twelve: CGFloat = 12
	}

	enum Scale {
		/// 1
		static let one: CGFloat = 1.0
		/// 1.8
		static let eighteen: CGFloat = 1.8
	}

	enum Time {
		/// 1 second.
		static let one: CGFloat = 1.0
		/// 2 second.
		static let two: CGFloat = 2.0
		/// 3 second.
		static let three: CGFloat = 3.0
		/// 4 second.
		static let four: CGFloat = 4.0
	}
}
