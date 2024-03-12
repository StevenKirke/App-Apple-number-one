//
//  IConfigurator.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

protocol IConfigurator: AnyObject {
	/// Сборщик сцены VIP, подключение Iterator, Presenter, менеджеров сети и других зависимостей.
	func configurator() -> UIViewController
}
