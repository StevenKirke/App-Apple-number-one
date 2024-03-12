//
//  TabBarPage.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

enum TabBarPage {
	case repair
	case status
	case profile
	case contact
	case stock

	var selectPage: Int {
		guard let currentIndex = TabBarPage.allTabBarPage.firstIndex(of: self) else { return .zero}
		return currentIndex
	}

	func pageTitle() -> String {
		var title = ""
		switch self {
		case .repair:
			title = "Ремонт"
		case .status:
			title = "Стутус"
		case .profile:
			title = "Профиль"
		case .contact:
			title = "Контакты"
		case .stock:
			title = "Акции"
		}
		return title
	}

	func pageImage() -> UIImage {
		var image = ""
		switch self {
		case .repair:
			image = "Images/Icons/Repair"
		case .status:
			image = "Images/Icons/Status"
		case .profile:
			image = "Images/Icons/User"
		case .contact:
			image = "Images/Icons/Contact"
		case .stock:
			image = "Images/Icons/Stock"
		}
		return UIImage(named: image) ?? .actions
	}

	static let allTabBarPage: [TabBarPage] = [.repair, .status, .profile, .contact, .stock]
	static let firstPage: TabBarPage = .repair
}
