//
//  ContactCoordinator.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class ContactCoordinator: ICoordinator {

	// MARK: - Public properties
	var childCoordinators: [ICoordinator] = []

	// MARK: - Dependencies

	// MARK: - Private properties
	private var navigationController: UINavigationController

	// MARK: - Initializator
	internal init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Lifecycle

	// MARK: - Public methods
	func start() {
		showMainContactScene()
	}

	// MARK: - Private methods
	private func showMainContactScene() {
		let assembler = AssemblerMainContact()
		let viewController = assembler.configurator()
		navigationController.pushViewController(viewController, animated: true)
	}
}
