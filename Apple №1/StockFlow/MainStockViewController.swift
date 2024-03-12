//
//  MainStockViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class MainStockViewController: UIViewController {

	// MARK: - Private properties
	private lazy var labelTitle = UILabel()

	// MARK: - Initializator
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfiguration()
		addUIView()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
	}
}

// - MARK: Add UIView in Controler
private extension MainStockViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		view.addSubview(labelTitle)
	}
}

// - MARK: Initialisation configuration
private extension MainStockViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		view.backgroundColor = Theme.backgroundColor

		// Настройка UILabel 'Название потока'
		labelTitle.text = "Repair flow."
		labelTitle.font = UIFont.systemFont(ofSize: 16)
		labelTitle.translatesAutoresizingMaskIntoConstraints = false
	}
}

// - MARK: Initialisation constraint elements.
private extension MainStockViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			labelTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
