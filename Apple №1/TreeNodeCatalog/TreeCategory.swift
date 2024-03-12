//
//  TreeModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 29.01.2024.
//

import Foundation

protocol ITreeNode {
	var id: String { get set }
	var parentID: String { get set }
	var title: String { get set }
	var items: [TreeOffer] { get }

	func add(item: TreeOffer)
	func getItems() -> [TreeOffer]
	func showItems()
}

final class TreeCategory: ITreeNode {

	// MARK: - Public properties
	var id: String
	var parentID: String
	var title: String
	var items: [TreeOffer]

	// MARK: - Initializator
	internal init(id: String, parentID: String, title: String, items: [TreeOffer]) {
		self.id = id
		self.parentID = parentID
		self.title = title
		self.items = items
	}

	// MARK: - Public methods
	func add(item: TreeOffer) {
		self.items.append(item)
	}

	func getItems() -> [TreeOffer] {
		self.items
	}

	func showItems() {
		items.forEach { print("\($0.id) \($0.name)") }
	}
}
