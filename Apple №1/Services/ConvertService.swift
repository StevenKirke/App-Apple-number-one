//
//  ConvertService.swift
//  Apple №1
//
//  Created by Steven Kirke on 28.01.2024.
//

import Foundation
/*
protocol IConvertService: AnyObject {
	/// Конвертация данных из JSON в дерево.
	func convert(catalogListDTO: CatalogListDTO) -> TreeNode<ITreeNode>
}

final class ConvertService: IConvertService {

	private var categories: [Category] = []
	private var offers: [Offer] = []

	func convert(catalogListDTO: CatalogListDTO) -> TreeNode<ITreeNode> {
		var result: TreeNode<ITreeNode> = TreeNode(value: TreeCategory(id: "", parentID: "", title: "", items: []))
		categories = catalogListDTO.ymlCatalog.shop.categories.category
		offers = catalogListDTO.ymlCatalog.shop.offers.offer
		// Поиск главной категории.
		if let root = categories.first(where: { $0.parentID == nil }) {
			let rootCategory = TreeCategory(id: root.id, parentID: root.parentID ?? "", title: root.text, items: [])
			result = TreeNode(value: rootCategory)

			// Поиск категорий устройств.
			for category in categories where category.parentID != nil {
				if result.value.id == category.parentID {
					// Поиск моделей устройств.
					let model = iterating(currentID: category.id)
					let device: TreeNode<ITreeNode> = TreeNode(value: TreeCategory(
						id: category.id,
						parentID: category.parentID ?? "",
						title: category.text,
						items: [])
					)
					device.addChilds(model)
					result.addChild(device)
				}
			}
		}
		// showTrees(tree: result)
		return result
	}
	/// Перебор и поиск неиспрвностей.
	private func iterating(currentID: String) -> [TreeNode<ITreeNode>] {
		var result: [TreeNode<ITreeNode>] = []
		for category in categories where category.parentID == currentID {
			// Поиск неисправностей у текущей модели.
			let repairs = addRepair(model: category.id)
			let model: TreeNode<ITreeNode> = TreeNode(value: TreeCategory(
				id: category.id,
				parentID: category.parentID ?? "",
				title: category.text,
				items: repairs
			))
			result.append(model)
		}
		return result
	}
	/// Добавление неисправностей, для устройства.
	private func addRepair(model: String) -> [TreeOffer] {
		var repairs: [TreeOffer] = []
		for offer in offers {
			for id in offer.categoryID.array where id == model {
				let currentRepair = TreeOffer(
					id: offer.id,
					currency: offer.currencyID.rawValue,
					name: offer.name,
					description: offer.description.title,
					price: offer.price,
					imageURL: offer.picture,
					available: offer.available
				)
				repairs.append(currentRepair)
			}
		}
		return repairs
	}
	/// Просмотр нодового дерева.
	private func showTrees(tree: TreeNode<ITreeNode>) {
		let space = "   "
		print("|---Root:")
		for device in tree.children {
			print("|\(space)|----\(device.value.id): \(device.value.title)")
			for model in device.children {
				print("|\(space)|\(space)|----\(model.value.id): \(model.value.title)")
				for repair in model.value.items {
					print("|\(space)|\(space)|\(space)|----\(repair.id): \(repair.name)")
					print("|\(space)|\(space)|\(space)|\(space)|----\(repair.description)")
				}
			}
		}
	}
}

*/
