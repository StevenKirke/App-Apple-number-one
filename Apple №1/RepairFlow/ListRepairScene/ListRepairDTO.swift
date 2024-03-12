//
//  ListRepairDTO.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.03.2024.
//

import Foundation

// MARK: - Repair
struct ListRepairDTO: Decodable {
	let ymlCatalog: ListRepairCatalog

	enum CodingKeys: String, CodingKey {
		case ymlCatalog = "yml_catalog"
	}
}

struct ListRepairCatalog: Decodable {
	let shop: ListRepairShopDTO

	enum CodingKeys: String, CodingKey {
		case shop
	}
}

struct ListRepairShopDTO: Decodable {
	let offers: ListRepairOffersDTO
}

struct ListRepairOffersDTO: Decodable {
	let offer: [ListRepairOfferDTO]
}

struct ListRepairOfferDTO: Decodable {
	let price: String
	let categoryID: ListRepairCategoryIDDTO
	let picture: String?
	let name: String
	let description: ListRepairDescriptionUnionDTO
	let id: String
	let available: String

	enum CodingKeys: String, CodingKey {
		case price
		case categoryID = "categoryId"
		case picture
		case name
		case description
		case id = "_id"
		case available = "_available"
	}
}

enum ListRepairCategoryIDDTO: Codable {
	case string(String)
	case stringArray([String])

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let array = try? container.decode([String].self) {
			self = .stringArray(array)
			return
		}
		if let string = try? container.decode(String.self) {
			self = .string(string)
			return
		}
		throw DecodingError.typeMismatch(
			ListRepairCategoryIDDTO.self,
			DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CategoryID")
		)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let string):
			try container.encode(string)
		case .stringArray(let array):
			try container.encode(array)
		}
	}
}

enum ListRepairDescriptionUnionDTO: Codable {
	case descriptionClass(ListRepairDescriptionClassDTO)
	case string(String)

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let text = try? container.decode(String.self) {
			self = .string(text)
			return
		}
		if let elementSpan = try? container.decode(ListRepairDescriptionClassDTO.self) {
			self = .descriptionClass(elementSpan)
			return
		}
		throw DecodingError.typeMismatch(
			ListRepairDescriptionUnionDTO.self,
			DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DescriptionUnion")
		)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .descriptionClass(let descriptionClass):
			try container.encode(descriptionClass)
		case .string(let text):
			try container.encode(text)
		}
	}
}

// MARK: - DescriptionClass
struct ListRepairDescriptionClassDTO: Codable {
	let span: ListRepairSpanDTO
}

// MARK: - Span
struct ListRepairSpanDTO: Codable {
	let style, text: String

	enum CodingKeys: String, CodingKey {
		case style = "_style"
		case text = "__text"
	}
}

extension ListRepairCategoryIDDTO {
	var array: [Int] {
		switch self {
		case .string(let value):
			return Self.convertTOInt(arrayString: [value])
		case .stringArray(let values):
			return Self.convertTOInt(arrayString: values)
		}
	}

	private static func convertTOInt(arrayString: [String]) -> [Int] {
		var currentArray: [Int] = []
		_ = arrayString.map {
			if let number = Int($0) {
				currentArray.append(number)
			}
		}
		return currentArray
	}
}

extension ListRepairDescriptionUnionDTO {
	var title: String {
		switch self {
		case .descriptionClass(let span):
			let text = span.span.text
			let removeSlash = text.replacingOccurrences(of: "\\", with: "")
			return removeSlash
		case .string(let text):
			return text
		}
	}
}
