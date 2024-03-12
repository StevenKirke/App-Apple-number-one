//
//  ListRepairAssembler.swift
//  Apple №1
//
//  Created by Steven Kirke on 25.02.2024.
//

import UIKit

final class ListRepairAssembler {
	func configurator(
		alertDelegate: IAlertDelegate,
		modelDevice: ListRepairModel.RequestListRepair.Device,
		showOrderRepairScene: IShowOrderRepairDelegate
	) -> UIViewController {
		// Менеджер чтения из файла.
		let fileManager = LoadFileManager()
		// Менеджер декодирования JSON.
		let decodeJSONManger = DecodeJsonManager()

		// Конвертация и выборка из JSON, списка неисправностей.
		let converterRepairDTO = ConvertorRepairModelDTO()

		let worker = ListRepairWorker(
			fileManager: fileManager,
			decodeJSONManager: decodeJSONManger,
			convertorDTO: converterRepairDTO
		)

		// Подключение VIP цикла.
		let viewController = ListRepairViewController()
		let presenter = ListRepairPresenter(
			viewController: viewController,
			showAlertDelegate: alertDelegate,
			showOrderRepairDelegate: showOrderRepairScene
		)
		let iterator = ListRepairIterator(
			worker: worker,
			presenter: presenter,
			modelDeviceForTransfer: modelDevice
		)

		viewController.iterator = iterator

		return viewController
	}
}
