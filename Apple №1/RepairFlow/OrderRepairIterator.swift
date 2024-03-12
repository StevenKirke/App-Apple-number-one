//
//  OrderRepairIterator.swift
//  Apple №1
//
//  Created by Steven Kirke on 05.03.2024.
//

import Foundation

protocol IOrderRepairIterator: AnyObject {
	func fitchDeviceTitle()
	func fitchRepairDescription()
	func fitchImage()
}

final class OrderRepairIterator {

	// MARK: - Dependencies
	let worker: IOrderRepairWorker
	let presenter: IOrderRepairPresenter
	let modelDeviceTitle: String
	let modelRepairForTransfer: OrderRepairModel.RequestOrderRepair.Repair

	internal init(
		worker: IOrderRepairWorker,
		presenter: IOrderRepairPresenter,
		modelDeviceTitle: String,
		modelRepairForTransfer: OrderRepairModel.RequestOrderRepair.Repair
	) {
		self.worker = worker
		self.presenter = presenter
		self.modelDeviceTitle = modelDeviceTitle
		self.modelRepairForTransfer = modelRepairForTransfer
	}
}

extension OrderRepairIterator: IOrderRepairIterator {
	func fitchDeviceTitle() {
		presenter.presentDeviceTitle(present: .showDeviceTitle(modelDeviceTitle))
	}

	func fitchImage() {
		let urlImage = modelRepairForTransfer.picture
		worker.getImage(imageURL: urlImage) { [weak self] resultImage in
			guard let self = self else { return }
			switch resultImage {
			case .success(let imageData):
				self.presenter.presentImage(present: .showImage(imageData))
			case .failure(let error):
				self.presenter.presentImage(present: .failure(error))
			}
		}
	}

	func fitchRepairDescription() {
		let modelPresent = OrderRepairModel.ResponseRepair.Repair(from: modelRepairForTransfer)
		presenter.presentRepairDescription(present: .showRepairDescription(modelPresent))
	}
}
