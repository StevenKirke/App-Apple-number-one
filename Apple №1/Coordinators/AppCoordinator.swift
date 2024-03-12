//
//  AppCoordinator.swift
//  Apple №1-
//
//  Created by Steven Kirke on 01.01.2024.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

	// MARK: - Dependencies
	private var navigationController: UINavigationController
	private var window: UIWindow?

	// MARK: - Private properties

	// MARK: - Initializator
	internal init(window: UIWindow?) {
		self.window = window
		self.navigationController = UINavigationController()
	}

	// MARK: - Internal methods
	override func start() {
		runLoginFlow()
	}

	// MARK: - Public methods
	func runLoginFlow() {
		let coordinator = LoginCoordinator(navigationController: navigationController)
		addDependency(coordinator)
		coordinator.finishFlow = {
			self.runMainFlow()
		}

		childCoordinators.append(coordinator)
		coordinator.start()

		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}

	func runMainFlow() {
		let tabBrController = TabBarController()
		let coordinator = MainCoordinator(tabBarController: tabBrController)
		addDependency(coordinator)
		coordinator.start()

		navigationController.isNavigationBarHidden = true
		navigationController.setViewControllers([tabBrController], animated: true)
	}
}
