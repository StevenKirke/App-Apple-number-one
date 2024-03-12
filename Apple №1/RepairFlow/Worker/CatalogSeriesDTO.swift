//
//  CatalogSeriesDTO.swift
//  Apple №1
//
//  Created by Steven Kirke on 24.02.2024.
//

import Foundation

// MARK: - Device and Series
struct CatalogSeriesDTO: Decodable {
	let ymlCatalog: YmlCatalogDTO

	enum CodingKeys: String, CodingKey {
		case ymlCatalog = "yml_catalog"
	}
}

// MARK: - YmlCatalog
struct YmlCatalogDTO: Decodable {
	let shop: ShopDTO

	enum CodingKeys: String, CodingKey {
		case shop
	}
}

// MARK: - Shop
struct ShopDTO: Decodable {
	let categories: CategoriesDTO
}

// MARK: - Categories
struct CategoriesDTO: Codable {
	let category: [CategoryDTO]
}

// MARK: - Category
struct CategoryDTO: Codable {
	let id: String
	let	text: String
	let parentID: String?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case text = "__text"
		case parentID = "_parentId"
	}
}
