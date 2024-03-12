//
//  AssemblerURLService.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import Foundation

protocol IAssemblerURLService: AnyObject {
	/// Сборщик Request.
	func assemblerYandexURL(coordinate: MainContactModel.Request.Coordinates) -> URL?
}

struct CoordinatesForYandex {
	let latitude: Double
	let longitude: Double
}

final class AssemblerURLService: IAssemblerURLService {
	func assemblerYandexURL(coordinate: MainContactModel.Request.Coordinates) -> URL? {
		let assemblerCoordinate = "\(coordinate.longitude),\(coordinate.latitude)"
		let zoom = "\(coordinate.zoom)"
		let marker = "\(coordinate.flag.longitude),\(coordinate.flag.latitude),flag"
		var components = URLComponents()
		components.scheme = "https"
		components.host = "static-maps.yandex.ru"
		components.path = "/v1"
		components.queryItems = [
			 URLQueryItem(name: "lang", value: "ru_RU"),
			 URLQueryItem(name: "apikey", value: "27086cd2-e462-4317-8a6f-cc8cf5b6e0fb"),
			 URLQueryItem(name: "ll", value: assemblerCoordinate),
			 URLQueryItem(name: "size", value: "450,450"),
			 URLQueryItem(name: "z", value: zoom),
			 URLQueryItem(name: "scale", value: "1.0"),
			 URLQueryItem(name: "pt", value: marker)
		 ]
		return components.url
	}
}
