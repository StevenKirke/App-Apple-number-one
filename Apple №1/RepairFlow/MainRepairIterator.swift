//
//  MainRepairIterator.swift
//  Apple №1
//
//  Created by Steven Kirke on 24.01.2024.
//

import Foundation

protocol IMainRepairIterator: AnyObject {
	/// Запрос списка моделей.
	func fetchDevices()
	/// Запрос модельного ряда и списка устройств.
	func fetchSeriesAndModel(device: MainRepairSeriesModel.RequestSeries.Devices)

	func nextScene(device: MainRepairSeriesModel.RequestSeries.Devices)
}

final class MainRepairIterator {

	// MARK: - Dependencies
	var presenter: IMainRepairPresenter
	var worker: IMainRepairWorker

	// MARK: - Initializator
	internal init(
		presenter: IMainRepairPresenter,
		worker: IMainRepairWorker
	) {
		self.presenter = presenter
		self.worker = worker
	}
}

// MARK: - Fetch datas.
extension MainRepairIterator: IMainRepairIterator {
	// Получить категорий устройств.
	func fetchDevices() {
		DispatchQueue.main.async {
			self.worker.getDataDevices { [weak self] response in
				guard let self = self else { return }
				switch response {
				case .success(let categories):
					self.presenter.presentDevices(responseDevices: .success(categories))
				case .failure(let error):
					self.presenter.presentDevices(responseDevices: .failure(error))
				}
			}
		}
	}

	// Получить список серии и моделей для категории, по ID.
	func fetchSeriesAndModel(device: MainRepairSeriesModel.RequestSeries.Devices) {
		DispatchQueue.main.async {
			self.worker.getDataSeriesAndModel(device: device) { [weak self] response in
				guard let self = self else { return }
				switch response {
				case .success(let series):
					self.presenter.presentSeries(responseSeries: .success(series))
				case .failure(let error):
					self.presenter.presentSeries(responseSeries: .failure(error))
				}
			}
		}
	}
}

// MARK: - Navigation.
extension MainRepairIterator {
	func nextScene(device: MainRepairSeriesModel.RequestSeries.Devices) {
		presenter.nextScene(device: device)
	}
}
