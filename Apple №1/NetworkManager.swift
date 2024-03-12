//
//  NetworkManager.swift
//  Apple №1
//
//  Created by Steven Kirke on 24.01.2024.
//

import Foundation

protocol INetworkManager: AnyObject {
	func getData(url: String, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void)
	func getDataURL(url: URL?, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void)
}

enum ErrorResponse: LocalizedError {
	/// Ошибка, конвертации URL.
	case errorConvertURL
	/// Ошибка, состояния ответа HTTP.
	case errorResponse
	/// Ошибка, запроса HTTP.
	case errorRequest(String)
	/// Пустая Data.
	case errorEmptyData

	var errorDescription: String? {
		var textError = ""
		switch self {
		case .errorConvertURL:
			textError = "Invalid URL conversion."
		case .errorResponse:
			textError = "Invalid RequestTest received from the server."
		case .errorRequest(let error):
			textError = "Post ResponseSeries -  \(error)"
		case .errorEmptyData:
			textError = "Nil Data."
		}
		return textError
	}
}

final class NetworkManager: INetworkManager {
	// MARK: - Private properties
	private let task = URLSession.shared

	// MARK: - Public methods
	func getData(url: String, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void) {
		guard let url = URL(string: url) else {
			returnModel(.failure(.errorConvertURL))
			return
		}

		let request = URLRequest(url: url)

		let dataTask = task.dataTask(with: request) { data, response, error in
			DispatchQueue.main.async {
				if let currentError = error {
					returnModel(.failure(.errorRequest(currentError.localizedDescription)))
				}
				if let currentResponse = response as? HTTPURLResponse, currentResponse.statusCode != 200 {
					returnModel(.failure(.errorResponse))
				}

				guard let currentData = data else {
					returnModel(.failure(.errorEmptyData))
					return
				}

				returnModel(.success(currentData))
			}
		}
		dataTask.resume()
	}

	func getDataURL(url: URL?, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void) {
		guard let currentURL = url else {
			returnModel(.failure(.errorConvertURL))
			return
		}
		let request = URLRequest(url: currentURL)
		let dataTask = task.dataTask(with: request) { data, response, error in
			DispatchQueue.main.async {
				if let currentError = error {
					returnModel(.failure(.errorRequest(currentError.localizedDescription)))
				}
				if let currentResponse = response as? HTTPURLResponse, currentResponse.statusCode != 200 {
					returnModel(.failure(.errorResponse))
				}

				guard let currentData = data else {
					returnModel(.failure(.errorEmptyData))
					return
				}

				returnModel(.success(currentData))
			}
		}
		dataTask.resume()
	}
}
