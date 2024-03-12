//
//  TreeOffer.swift
//  Apple №1
//
//  Created by Steven Kirke on 28.01.2024.
//

import Foundation

enum TreeCurrency {
	case RUB
}

final class TreeOffer {
	/// ID.
	let id: String
	/// Валюта.
	let currency: String
	/// Название неисправности.
	let name: String
	/// Описание неисправности.
	let description: String
	/// Цена ремонта.
	let price: String
	/// Изображение.
	let imageURL: URL?
	/// Поле описывающее есть ли запчасть.
	var available: Bool

	internal init(
		id: String,
		currency: String,
		name: String,
		description: String,
		price: String,
		imageURL: String?,
		available: String
	) {
		self.id = id
		self.currency = currency
		self.name = name
		self.description = description
		self.price = price
		self.imageURL = Self.urlString(picture: imageURL)
		self.available =  Self.parseAvailable(available)
	}

	private static func parseAvailable(_ available: String) -> Bool {
		var result: Bool = false
		if case available.uppercased() = "true" {
			result = true
		}
		return result
	}

	private static func urlString(picture: String?) -> URL? {
		guard let currentPicture = picture else { return nil }
		return URL(string: currentPicture)
	}
}
