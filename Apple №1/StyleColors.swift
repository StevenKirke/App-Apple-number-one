//
//  StyleColors.swift
//  Apple №1
//
//  Created by Steven Kirke on 23.01.2024.
//

import UIKit

enum FlatColor {

	enum White {
		static let light = UIColor(hex: "#FFFFFF")
		static let dark = UIColor(hex: "#000000")
	}

	enum Dark {
		static let light = UIColor(hex: "#FFFFFF")
		static let dark = UIColor(hex: "#000000")
	}

	enum Gray {
		static let light = UIColor(hex: "#E9E9EB")
		static let dark = UIColor(hex: "#39393D")
	}
}

enum Colors {
	static let light = UIColor.color(light: FlatColor.White.dark, dark: FlatColor.White.light)
	static let grey = UIColor.color(light: FlatColor.Gray.light, dark: FlatColor.Gray.dark)
	static let dark = UIColor.color(light: FlatColor.Dark.light, dark: FlatColor.Dark.dark)
}

enum Theme {
	/// Цвет текста, рамок.
	static let mainColor = Colors.light
	static let accentColor = Colors.grey
	/// Цвет заднего фона, плашек и т. п.
	static let backgroundColor = Colors.dark
}
