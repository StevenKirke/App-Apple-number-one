//
//  MainCoordinator.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class MainCoordinator: BaseCoordinator {

	// MARK: - Dependencies
	private let tabBarController: UITabBarController

	// MARK: - Private properties
	private let pages: [TabBarPage] = TabBarPage.allTabBarPage

	// MARK: - Initialisation
	init(tabBarController: UITabBarController) {
		self.tabBarController = tabBarController
	}

	// MARK: - Internal methods
	override func start() {
		tabBarController.viewControllers?.enumerated().forEach { item in
			guard let controller = item.element as? UINavigationController else { return }
			getTabController(item.offset, on: controller)
		}
	}
}

// MARK: - Run flow.
private extension MainCoordinator {
	/// Запуск потоков меню.
	/// - Parameters:
	///   - index: Индекс из перечисления.
	///   - controller: Текущий UINavigationController.
	func getTabController(_ index: Int, on controller: UINavigationController) {
		let coordinator: ICoordinator
		switch pages[index] {
		case .repair:
			coordinator = RepairCoordinator(navigationController: controller)
		case .status:
			coordinator = StatusCoordinator(navigationController: controller)
		case .profile:
			coordinator = ProfileCoordinator(navigationController: controller)
		case .contact:
			coordinator = ContactCoordinator(navigationController: controller)
		case .stock:
			coordinator = StockCoordinator(navigationController: controller)
		}
		addDependency(coordinator)
		coordinator.start()
	}
}
