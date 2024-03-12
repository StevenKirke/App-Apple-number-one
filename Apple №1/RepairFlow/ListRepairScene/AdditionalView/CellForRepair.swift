//
//  CustomCellForRepair.swift
//  Apple №1
//
//  Created by Steven Kirke on 03.03.2024.
//

import UIKit

// MARK: - CustomCellForRepair
final class CellForRepair: UICollectionViewCell {

	// MARK: - Public properties
	static let reuseIdentifier = "CellForRepair.cell"

	// MARK: - Private properties
	private lazy var labelTitle = createLabel()
	private lazy var labelDescription = createLabel()
	private lazy var separator = createView()

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

	// MARK: - Public methods
	func reloadData(title: String, description: String) {
		labelTitle.text = title
		labelDescription.text = description
	}
}

// MARK: - Add UIView.
private extension CellForRepair {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			labelTitle,
			separator,
			labelDescription
		]
		views.forEach(contentView.addSubview)
	}
}

// MARK: - UI configuration.
private extension CellForRepair {
	/// Настройка UI элементов
	func setupConfiguration() {
		contentView.backgroundColor = Colors.grey
		contentView.layer.borderWidth = 1
		contentView.layer.cornerRadius = Styles.Radius.radiusTextField

		labelTitle.textColor = Theme.mainColor

		labelDescription.numberOfLines = 4
		labelDescription.textAlignment = .left

		separator.backgroundColor = Theme.mainColor
		separator.layer.cornerRadius = Styles.Radius.radiusOne
	}
}

// MARK: - Add constraint.
private extension CellForRepair {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
			labelTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
			labelTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
			labelTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),

			separator.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 0),
			separator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
			separator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
			separator.heightAnchor.constraint(equalToConstant: 2),

			labelDescription.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5),
			labelDescription.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
			labelDescription.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
		])
	}
}

// MARK: - UI Fabric.
private extension CellForRepair {
	func createLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
}
