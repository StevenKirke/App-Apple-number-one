//
//  AssemblerMainRepair.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class MainRepairAssembler {
	func configurator(
		alertDelegate: IAlertDelegate, showListRepairDelegate: IShowListRepairDelegate
	) -> UIViewController {
		// Менеджер чтения из файла.
		let fileManager = LoadFileManager()
		// Менеджер декодирования JSON.
		let decodeJSONManger = DecodeJsonManager()

		// Конвертация и выборка из JSON, cписка типов устройств.
		let converterDevicesDTO = ConvertorDevicesDTO()
		// Конвертация и выборка из JSON серии и моделей для определенного типа устройств.
		let converterSeriesDTO = ConvertToSeriesAndModelDTO()

		// Подключение Worker, запросы к данным, декодирование.
		let worker = MainRepairWorker(
			fileManager: fileManager,
			decodeJSONManager: decodeJSONManger,
			convertorDevices: converterDevicesDTO,
			convertorSeries: converterSeriesDTO
		)
		// Подключение VIP цикла.
		let viewController = MainRepairViewController()
		let presenter = MainRepairPresenter(
			viewController: viewController,
			showAlertDelegate: alertDelegate,
			showListRepairDelegate: showListRepairDelegate
		)
		let iterator = MainRepairIterator(
			presenter: presenter,
			worker: worker
		)

		viewController.iterator = iterator

		return viewController
	}
}
