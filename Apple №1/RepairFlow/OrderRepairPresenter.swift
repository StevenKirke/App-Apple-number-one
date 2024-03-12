//
//  OrderRepairPresenter.swift
//  Apple №1
//
//  Created by Steven Kirke on 05.03.2024.
//

import Foundation

protocol IOrderRepairPresenter: AnyObject {
	/// Отображение название ремонтируемого устройства.
	func presentDeviceTitle(present: OrderRepairModel.ResponseRepair)
	/// Отображение изображения из описания неисправности.
	func presentImage(present: OrderRepairModel.ResponseRepair)
	/// Отображение неисправности, описание, цена.
	func presentRepairDescription(present: OrderRepairModel.ResponseRepair)
}

final class OrderRepairPresenter {

	// MARK: - Dependencies
	private var showAlertDelegate: IAlertDelegate

	// MARK: - Lifecycle
	private weak var viewController: IOrderRepairViewLogic?

	// MARK: - Initializator
	internal init(viewController: IOrderRepairViewLogic, showAlertDelegate: IAlertDelegate) {
		self.viewController = viewController
		self.showAlertDelegate = showAlertDelegate
	}
}

extension OrderRepairPresenter: IOrderRepairPresenter {
	func presentDeviceTitle(present: OrderRepairModel.ResponseRepair) {
		if case .showDeviceTitle(let title) = present {
			viewController?.renderDisplayTitle(modelTitle: title)
		}
	}

	func presentImage(present: OrderRepairModel.ResponseRepair) {
		if case .showImage(let data) = present {
			viewController?.renderImage(imageData: data)
		}
		if case .failure(let error) = present {
			showAlertDelegate.showAlertView(massage: error)
		}
	}

	func presentRepairDescription(present: OrderRepairModel.ResponseRepair) {
		if case let .showRepairDescription(repair) = present {
			let model = OrderRepairModel.ViewModel.Repair(from: repair)
			viewController?.renderRepairDescription(modelRepairDesc: model)
		}
	}
}
