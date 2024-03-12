//
//  ListRepairIterator.swift
//  Apple №1
//
//  Created by Steven Kirke on 25.02.2024.
//

import Foundation

protocol IListRepairIterator: AnyObject {
	func fitchNameDevice()
	func fitchRepairList()
	func nextScene(deviceTitle: String, modelRepair: ListRepairModel.ViewModel.Repair)
}

final class ListRepairIterator {

	// MARK: - Dependencies
	let worker: IListRepairWorker
	let presenter: IListRepairPresenter
	let modelDeviceForTransfer: ListRepairModel.RequestListRepair.Device

	// MARK: - Initializator
	internal init(
		worker: IListRepairWorker,
		presenter: IListRepairPresenter,
		modelDeviceForTransfer: ListRepairModel.RequestListRepair.Device
	) {
		self.worker = worker
		self.presenter = presenter
		self.modelDeviceForTransfer = modelDeviceForTransfer
	}
}

// MARK: - Fetch datas.
extension ListRepairIterator: IListRepairIterator {
	func fitchNameDevice() {
		self.presenter.presentRepairList(presentRepairList: .showTitle(modelDeviceForTransfer.name))
	}

	func fitchRepairList() {
		worker.getRepairList(device: modelDeviceForTransfer) { [weak self] resultRepairList in
			guard let self = self else { return }
			switch resultRepairList {
			case .success(let repairList):
				self.presenter.presentRepairList(presentRepairList: .showRepairList(repairList))
			case .failure(let error):
				self.presenter.presentRepairList(presentRepairList: .failure(error))
			}
		}
	}
}

// MARK: - Navigation.
extension ListRepairIterator {
	func nextScene(deviceTitle: String, modelRepair: ListRepairModel.ViewModel.Repair) {
		presenter.nextScene(deviceTitle: deviceTitle, modelRepair: modelRepair)
	}
}
