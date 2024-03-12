//
//  AssemblerMainStock.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class AssemblerMainStock: IConfigurator {
	func configurator() -> UIViewController {
		let viewController = MainStockViewController()

		return viewController
	}
}
