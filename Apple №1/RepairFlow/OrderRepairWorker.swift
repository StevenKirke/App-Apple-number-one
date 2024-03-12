//
//  OrderRepairWorker.swift
//  Apple №1
//
//  Created by Steven Kirke on 09.03.2024.
//

import Foundation

protocol IOrderRepairWorker: AnyObject {
	func getImage(imageURL: String, resultData: @escaping (Result<Data, Error>) -> Void)
}

final class OrderRepairWorker: IOrderRepairWorker {

	// MARK: - Dependencies
	let networkManager: INetworkManager

	internal init(networkManager: INetworkManager) {
		self.networkManager = networkManager
	}

	func getImage(imageURL: String, resultData: @escaping (Result<Data, Error>) -> Void) {
		networkManager.getData(url: imageURL) { result in
			switch result {
			case .success(let data):
				resultData(.success(data))
			case .failure(let error):
				resultData(.failure(error))
			}
		}
	}
}
