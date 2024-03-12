//
//  OrderRepairAssembler.swift
//  Apple №1
//
//  Created by Steven Kirke on 05.03.2024.
//

import UIKit

final class OrderRepairAssembler {
	func configurator(
		modelDeviceTitle: String,
		modelTransfer: OrderRepairModel.RequestOrderRepair.Repair,
		alertDelegate: IAlertDelegate
	) -> UIViewController {
		// Менеджер работы с сетью.
		let networkManager = NetworkManager()

		let worker = OrderRepairWorker(networkManager: networkManager)
		// Подключение VIP цикла.
		let viewController = OrderRepairViewController()
		let presenter = OrderRepairPresenter(viewController: viewController, showAlertDelegate: alertDelegate)
		let iterator = OrderRepairIterator(
			worker: worker,
			presenter: presenter,
			modelDeviceTitle: modelDeviceTitle,
			modelRepairForTransfer: modelTransfer
		)

		viewController.iterator = iterator

		return viewController
	}
}
