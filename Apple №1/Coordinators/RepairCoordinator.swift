//
//  RepairCoordinator.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

// Протокол для подключения AlertView, отображение ошибок.
protocol IAlertDelegate: AnyObject {
	/**
	 Показ ошибки. Критической и/или влияющей на дальнейшую работу приложения.
	 - Parameters:
			- massage: Тип Error.
	 */
	func showAlertView(massage: Error)
}

/// Делегат, перехода на сцену со списком видов ремонта для выбранного устройства.
protocol IShowListRepairDelegate: AnyObject {
	/// Переход на следующую сцену.
	/// - Parameters:
	///     - modelDevice: Модель устройства.
	func showListRepairScene(modelDevice: MainRepairSeriesModel.RequestSeries.Devices)
}

/// Делегат, для перехода на сцену с описанием определенного вида ремонта.
protocol IShowOrderRepairDelegate: AnyObject {
	/// Переход на следующую сцену.
	/// - Parameters:
	///     - modelRepair: Модель описания неисправности.
	func showOrderRepairScene(deviceTitle: String, modelRepair: ListRepairModel.ViewModel.Repair)
}

final class RepairCoordinator: ICoordinator {

	// MARK: - Public properties
	var childCoordinators: [ICoordinator] = []

	// MARK: - Private properties
	private var navigationController: UINavigationController

	// MARK: - Initializator
	internal init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Public methods
	func start() {
		 showMainRepairScene()
		//  showOrderRepairSceneFake()
	}

	// MARK: - Private methods
	private func showMainRepairScene() {
		let assembler = MainRepairAssembler()
		let viewController = assembler.configurator(alertDelegate: self, showListRepairDelegate: self)
		navigationController.pushViewController(viewController, animated: true)
	}
}

// MARK: - Protocol IShowListRepairDelegate.
// Отображение сцены со списком видов ремонта для конкретной модели устройства.
extension RepairCoordinator: IShowListRepairDelegate {
	func showListRepairScene(modelDevice: MainRepairSeriesModel.RequestSeries.Devices) {
		let convertModel = ListRepairModel.RequestListRepair.Device(
			deviceID: modelDevice.deviceID,
			parentID: modelDevice.parentID,
			name: modelDevice.title
		)
		let assembler = ListRepairAssembler()
		let viewController = assembler.configurator(
			alertDelegate: self,
			modelDevice: convertModel,
			showOrderRepairScene: self)
		navigationController.pushViewController(viewController, animated: true)
	}
}

// MARK: - IShowOrderRepairDelegate.
// Отображение сцены с описанием ремонта.
extension RepairCoordinator: IShowOrderRepairDelegate {
	func showOrderRepairScene(deviceTitle: String, modelRepair: ListRepairModel.ViewModel.Repair) {
		let convertModel = OrderRepairModel.RequestOrderRepair.Repair(
			id: modelRepair.id,
			title: modelRepair.title,
			description: modelRepair.description,
			price: modelRepair.price,
			available: modelRepair.available,
			picture: modelRepair.picture
		)
		let assembler = OrderRepairAssembler()
		let viewController = assembler.configurator(
			modelDeviceTitle: deviceTitle,
			modelTransfer: convertModel,
			alertDelegate: self
		)
		navigationController.pushViewController(viewController, animated: true)
	}
}

// MARK: - IAlertDelegate.
// Отображение сцены предупреждения или ошибки.
extension RepairCoordinator: IAlertDelegate {
	func showAlertView(massage: Error) {
		show(typeMassage: .errorBlock(massage: massage.localizedDescription))
	}
}

// MARK: - Add protocol ICustomUIAlertProtocol.
extension RepairCoordinator: ICustomUIAlertProtocol {
	func show(typeMassage: AlertMassageType) {
		let alertVC = CustomUIAlertController()
		alertVC.show(typeMassage: typeMassage)
		navigationController.present(alertVC, animated: true)
	}
}
