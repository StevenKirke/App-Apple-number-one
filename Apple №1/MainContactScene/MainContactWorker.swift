//
//  MainContactWorker.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import Foundation

protocol IMainContactWorker: AnyObject {
	/// Получение списка адресов мастерских.
	func getAddressList(resultAddress: @escaping (Result<[MainContactModel.Response.AddressWorkShop], Error>) -> Void)
	/// Получение текущей геолокации.
	func getCurrentLocation(
		resultLocation: @escaping (Result<MainContactModel.Response.Coordinates,Error>) -> Void
	) async
	/// Получение карты локации по координатам.
	func getMapForLocation(
		coordinate: MainContactModel.Request.Coordinates, resultMap: @escaping (Result<Data, Error>
		) -> Void)
}

final class MainContactWorker: IMainContactWorker {
	// MARK: - Dependencies
	let locationManager: ILocationManager
	let addressMock: AssemblerAddresses
	let networkManager: INetworkManager
	let assemblerYandexURL: IAssemblerURLService

	// MARK: - Initializator
	init(
		addressMock: AssemblerAddresses,
		networkManager: INetworkManager,
		assemblerYandexURL: IAssemblerURLService,
		locationManager: ILocationManager
	) {
		self.addressMock = addressMock
		self.networkManager = networkManager
		self.assemblerYandexURL = assemblerYandexURL
		self.locationManager = locationManager
	}

	func getAddressList(
		resultAddress: @escaping (Result<[MainContactModel.Response.AddressWorkShop], Error>) -> Void
	) {
		let addresses = addressMock.createAddresses()
		let convertModel = converter(modelDTO: addresses)
		resultAddress(.success(convertModel))
	}

	func getCurrentLocation(
		resultLocation: @escaping (Result<MainContactModel.Response.Coordinates, Error>) -> Void
	) async {
		await locationManager.getLocation { resultCurrentCoordinate in
			switch resultCurrentCoordinate {
			case .success(let coordinate):
				let model = MainContactModel.Response.Coordinates(
					latitude: coordinate.latitude,
					longitude: coordinate.longitude
				)
				resultLocation(.success(model))
			case .failure(let error):
				resultLocation(.failure(error))
			}
		}
	}

	func getMapForLocation(
		coordinate: MainContactModel.Request.Coordinates, resultMap: @escaping (Result<Data, Error>) -> Void
	) {
		let yandexURL = assemblerYandexURL.assemblerYandexURL(coordinate: coordinate)
		networkManager.getDataURL(url: yandexURL) { resultData in
			switch resultData {
			case .success(let data):
				resultMap(.success(data))
			case .failure(let error):
				resultMap(.failure(error))
			}
		}
	}
}

private extension MainContactWorker {
	func converter(modelDTO: [AddressWorkShop]) -> [MainContactModel.Response.AddressWorkShop] {
		let convert = modelDTO.map {
			MainContactModel.Response.AddressWorkShop(
				title: $0.title,
				address: $0.address,
				coordinate: MainContactModel.Response.Coordinates(
					latitude: $0.coordinate.latitude,
					longitude: $0.coordinate.longitude
				),
				flag: MainContactModel.Response.FlagCoordinates(
					latitude: $0.flag.latitude,
					longitude: $0.flag.longitude
				)
			)
		}
		return convert
	}
}
