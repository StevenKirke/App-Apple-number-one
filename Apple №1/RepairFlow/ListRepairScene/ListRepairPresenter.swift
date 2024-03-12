//
//  ListRepairPresenter.swift
//  Apple №1
//
//  Created by Steven Kirke on 25.02.2024.
//

import Foundation

protocol IListRepairPresenter: AnyObject {
	func presentTitle(presentTitle: String)
	func presentRepairList(presentRepairList: ListRepairModel.ResponseDevices)
	func nextScene(deviceTitle: String, modelRepair: ListRepairModel.ViewModel.Repair)
}

final class ListRepairPresenter {

	// MARK: - Dependencies
	private var showAlertDelegate: IAlertDelegate?
	private var showOrderRepairDelegate: IShowOrderRepairDelegate

	// MARK: - Lifecycle
	private weak var viewController: IListRepairViewLogic?

	// MARK: - Initializator
	internal init(
		viewController: IListRepairViewLogic?,
		showAlertDelegate: IAlertDelegate?,
		showOrderRepairDelegate: IShowOrderRepairDelegate
	) {
		self.viewController = viewController
		self.showAlertDelegate = showAlertDelegate
		self.showOrderRepairDelegate = showOrderRepairDelegate
	}
}

extension ListRepairPresenter: IListRepairPresenter {
	func presentTitle(presentTitle: String) {
		viewController?.renderTitle(nameDevice: presentTitle)
	}

	func presentRepairList(presentRepairList: ListRepairModel.ResponseDevices) {
		switch presentRepairList {
		case .showRepairList(let repairList):
			let model = repairList.map { ListRepairModel.ViewModel.Repair(from: $0) }
			viewController?.renderRepairList(viewModel: model)
		case .failure(let error):
			showAlertDelegate?.showAlertView(massage: error)
		case .showTitle(let title):
			let cropTitle = removeCharsFromTitle(title)
			viewController?.renderTitle(nameDevice: cropTitle)
		}
	}
}

// MARK: - Next scene.
extension ListRepairPresenter {
	func nextScene(deviceTitle: String, modelRepair: ListRepairModel.ViewModel.Repair) {
		showOrderRepairDelegate.showOrderRepairScene(deviceTitle: deviceTitle, modelRepair: modelRepair)
	}
}

private extension ListRepairPresenter {
	func removeCharsFromTitle(_ title: String) -> String {
		let pattern = "[А-Яа-я]"
		let replace = title.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
		let trim = replace.trimmingCharacters(in: .whitespaces)
		return trim
	}
}
