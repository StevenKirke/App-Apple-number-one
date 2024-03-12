//
//  AssemblerMainContact.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class AssemblerMainContact: IConfigurator {
	func configurator() -> UIViewController {
		// Менеджер работы с текущей геопозицией.
		let locationManager = LocationManager()
		// Менеджер работы с сетью.
		let networkManager = NetworkManager()
		// Сборщики URL.
		let assemblerYandexURL = AssemblerURLService()
		// Mock файл с адресами.
		let addressManagers = AssemblerAddresses()
		let worker = MainContactWorker(
			addressMock: addressManagers,
			networkManager: networkManager,
			assemblerYandexURL: assemblerYandexURL,
			locationManager: locationManager
		)
		// Подключение VIP цикла.
		let viewController = MainContactViewController()
		let presenter = MainContactPresenter(viewController: viewController)
		let iterator = MainContactIterator(presenter: presenter, worker: worker)

		viewController.iterator = iterator

		return viewController
	}
}
