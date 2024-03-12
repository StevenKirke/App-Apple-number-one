//
//  CellForSeries.swift
//  Apple №1
//
//  Created by Steven Kirke on 03.02.2024.
//

import UIKit

final class CellForSeries: UICollectionViewCell {

	// MARK: - Public properties
	static let reuseIdentifier = "CellForSeries.cell"

	// MARK: - Private properties
	private lazy var labelTitle = createUILabel()

	// MARK: - Initializator
	override init(frame: CGRect) {
		super.init(frame: frame)
		addUIView()
		setupConfiguration()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - Lifecycle

	// MARK: - Public methods
	func reloadData(title: String) {
		labelTitle.text = title
	}
}

// MARK: - Add UIView.
private extension CellForSeries {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [labelTitle]
		views.forEach(contentView.addSubview)
	}
}

// MARK: - UI configuration.
private extension CellForSeries {
	/// Настройка UI элементов
	func setupConfiguration() {
		labelTitle.textColor = Theme.mainColor
		labelTitle.layer.borderWidth = Styles.Border.one
		labelTitle.layer.cornerRadius = Styles.Radius.radiusTextField
	}
}

// MARK: - Add constraint.
private extension CellForSeries {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		let padding = Styles.Padding.self
		NSLayoutConstraint.activate([
			labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
			labelTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding.average),
			labelTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding.average),
			labelTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}

// MARK: - UI Fabric.
private extension CellForSeries {
	func createUILabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}
