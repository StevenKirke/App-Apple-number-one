//
//  TabBarController.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfiguration()
	}
}

// - MARK: Initialisation configuration
private extension TabBarController {
	/// Настройка UI элементов
	func setupConfiguration() {
		let controllers: [UINavigationController] = TabBarPage.allTabBarPage.map { getTabController(page: $0) }
		setViewControllers(controllers, animated: true)
		selectedIndex = TabBarPage.firstPage.selectPage
	}

	func getTabController(page: TabBarPage) -> UINavigationController {
		let navController = UINavigationController()
		_ = navController.tabBarController?.tabBar

		tabBar.frame.origin.y = 100
		tabBar.isTranslucent = false
		tabBar.backgroundColor = Theme.backgroundColor
		tabBar.tintColor = Theme.mainColor
		// tabBar.unselectedItemTintColor = Colors.light
		tabBar.scalesLargeContentImage = true

		navController.tabBarItem = UITabBarItem(
			title: page.pageTitle(),
			image: page.pageImage(),
			tag: page.selectPage
		)

		return navController
	}
}
