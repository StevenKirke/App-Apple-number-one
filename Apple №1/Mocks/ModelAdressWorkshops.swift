//
//  ModelAdressWorkshops.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import Foundation

struct AddressWorkShop {
	let title: String
	let address: String
	let coordinate: Coordinates
	let flag: FlagCoordinates
}

struct Coordinates {
	let latitude: Double
	let longitude: Double
}

struct FlagCoordinates {
	let latitude: Double
	let longitude: Double
}

final class AssemblerAddresses {

	func createAddresses() -> [AddressWorkShop] {
		[
			AddressWorkShop(
				title: "Apple №1 м. Таганская",
				address: "г. Москва, ул. Земляной Вал, д.72",
				coordinate: Coordinates(latitude: 55.744135, longitude: 37.654475),
				flag: FlagCoordinates(latitude: 55.744097, longitude: 37.654590)
			),
			AddressWorkShop(
				title: "Apple №1 на Семёновской",
				address: "г. Москва, ул. Ткацкая, д.5, с.2",
				coordinate: Coordinates(latitude: 55.786242, longitude: 37.723636),
				flag: FlagCoordinates(latitude: 55.786167, longitude: 37.723701)
			),
			AddressWorkShop(
				title: "Apple №1 на Преображенской",
				address: "г. Москва, ул. Преображенская пл., д. 8",
				coordinate: Coordinates(latitude: 55.794887, longitude: 37.712812),
				flag: FlagCoordinates(latitude: 55.795129, longitude: 37.713340)
			),
			AddressWorkShop(
				title: "Apple №1 м. Калужская",
				address: "г. Москва, ул. Бутлерова, д.17, БЦ «Neo Geo», торговая галерея, п. 3025.",
				coordinate: Coordinates(latitude: 55.650150, longitude: 37.539626),
				flag: FlagCoordinates(latitude: 55.649719, longitude: 37.539451)
			),
			AddressWorkShop(
				title: "Apple №1 в с. Эсто-Садок (Сочи)",
				address: "г. Сочи, с. Эсто-Садок, ул. Горная Карусель, д.3",
				coordinate: Coordinates(latitude: 43.683810, longitude: 40.263156),
				flag: FlagCoordinates(latitude: 43.683759, longitude: 40.262889)
			),
			AddressWorkShop(
				title: "Apple №1 в пгт. Красная Поляна на Турчинского",
				address: "г. Сочи, пгт. Красная Поляна, ул. Турчинского, д. 55",
				coordinate: Coordinates(latitude: 43.679377, longitude: 40.206077),
				flag: FlagCoordinates(latitude: 43.679375, longitude: 40.206082)
			)
		]
	}
}
