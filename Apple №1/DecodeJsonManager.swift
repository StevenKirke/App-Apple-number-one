//
//  DecodeJsonManager.swift
//  Apple №1
//
//  Created by Steven Kirke on 23.01.2024.
//

import Foundation

enum TestError: LocalizedError {
	case test(massage: String)

	var errorDescription: String? {
		switch self {
		case .test(massage: let massage):
			return "This is testing Error. This is long description This is long description \(massage)"
		}
	}
}

enum DecodeError: LocalizedError {
	case errorDecodeJson(String)
	case errorEncodeJson(String)
}

protocol IDecodeJsonManager {
	/**
	 Метод для декодирования Data в модель.
	 - Parameters:
			- data: Данные в формате Data.
			- model: Модель для декодирования, структура подписанная на Decodable.
	 - Throws: Возвращает ошибку, формата``DecodeError.errorDecodeJson``.
	 - Returns: Возвращает Result, модель или ошибку.
	 */
	func decodeJSON<T: Decodable>(data: Data, model: T.Type, returnJSON: @escaping (Result<T, DecodeError>) -> Void)
	/**
	 Метод кодирования структур в тип Data.
	 - Parameters:
			- data: Данные в формате Data.
			- model: Модель для декодирования, структура подписанная на Decodable.
	 - Throws: Возвращает ошибку, формата``DecodeError.errorDecodeJson``.
	 - Returns: Возвращает Result, модель или ошибку.
	 */
	func encodeJSON<T: Encodable>(models: T, returnData: @escaping (Result<Data, DecodeError>) -> Void)
}

final class DecodeJsonManager: IDecodeJsonManager {
	func decodeJSON<T: Decodable>(data: Data, model: T.Type, returnJSON: @escaping (Result<T, DecodeError>) -> Void) {
		DispatchQueue.main.async {
			do {
				let json = try JSONDecoder().decode(T.self, from: data)
				return returnJSON(.success(json))
			} catch let error {
				return returnJSON(.failure(.errorDecodeJson(error.localizedDescription)))
			}
		}
	}

	func encodeJSON<T: Encodable>(models: T, returnData: @escaping (Result<Data, DecodeError>) -> Void) {
		DispatchQueue.main.async {
			do {
				let data = try JSONEncoder().encode(models)
				returnData(.success(data))
			} catch let error {
				returnData(.failure(.errorEncodeJson(error.localizedDescription)))
			}
		}
	}
}
