//
//  MainStatusViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

final class MainStatusViewController: UIViewController {

	// MARK: - Public properties

	// MARK: - Dependencies

	// MARK: - Private properties
	private let customUI = FabricUI()
	private lazy var labelTitle = customUI.createLabel()

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
private extension MainStatusViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		view.addSubview(labelTitle)
	}
}

// - MARK: Initialisation configuration
private extension MainStatusViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		view.backgroundColor = Theme.backgroundColor

		// Настройка UILabel 'Название потока'
		labelTitle.text = "Status flow."
		labelTitle.font = UIFont.systemFont(ofSize: Styles.Fonts.bigger)
	}
}

// - MARK: Initialisation constraint elements.
private extension MainStatusViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			labelTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
