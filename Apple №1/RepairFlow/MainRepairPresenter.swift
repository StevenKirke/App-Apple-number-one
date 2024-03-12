//
//  MainRepairPresenter.swift
//  Apple №1
//
//  Created by Steven Kirke on 24.01.2024.
//

import Foundation

protocol IMainRepairPresenter: AnyObject {
	/// Метод открывающий ContactListViewController.
	func presentDevices(responseDevices: MainRepairDevicesModel.ResponseDevices)

	/// Метод отображение модели типа MainRepairSeriesModel.
	func presentSeries(responseSeries: MainRepairSeriesModel.ResponseSeries)
	/**
	 Переход на следующую сцену.
	 - Parameters:
		 - device: Передача данных по устройству.
	 */
	func nextScene(device: MainRepairSeriesModel.RequestSeries.Devices)
}

final class MainRepairPresenter {
	// MARK: - Dependencies
	private weak var viewController: IMainRepairViewLogic?
	private var showAlertDelegate: IAlertDelegate?
	private var showListRepairDelegate: IShowListRepairDelegate

	// MARK: - Initializator
	internal init(
		viewController: IMainRepairViewLogic?,
		showAlertDelegate: IAlertDelegate?,
		showListRepairDelegate: IShowListRepairDelegate
	) {
		self.viewController = viewController
		self.showAlertDelegate = showAlertDelegate
		self.showListRepairDelegate = showListRepairDelegate
	}
}

extension MainRepairPresenter: IMainRepairPresenter {
	// Получение модели из Iterator и последующая обработка для отображение во View.
	func presentDevices(responseDevices: MainRepairDevicesModel.ResponseDevices) {
		switch responseDevices {
		case .success(let devices):
			let devicesForModel = devices.map {
				MainRepairDevicesModel.ViewModel.Device(from: $0)
			}
			viewController?.renderDevices(viewModel: devicesForModel)
		case .failure(let error):
			showAlertDelegate?.showAlertView(massage: error)
		}
	}

	func presentSeries(responseSeries: MainRepairSeriesModel.ResponseSeries) {
		switch responseSeries {
		case .success(let series):
			let model = series.map { MainRepairSeriesModel.ViewModel.Series(from: $0) }
			viewController?.renderSeries(viewModel: model)
		case .failure(let error):
			showAlertDelegate?.showAlertView(massage: error)
		}
	}
}

// MARK: - Next scene.
extension MainRepairPresenter {
	func nextScene(device: MainRepairSeriesModel.RequestSeries.Devices) {
		showListRepairDelegate.showListRepairScene(modelDevice: device)
	}
}
