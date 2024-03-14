//
//  CellForContact.swift
//  Apple №1
//
//  Created by Steven Kirke on 10.03.2024.
//

import UIKit

final class CellForContact: UICollectionViewCell {

	// MARK: - Public properties
	static let reuseIdentifier = "cellForContact.cell"

	// MARK: - Private properties
	private lazy var labelTitle = createUILabel()
	private lazy var separator = createSeparator()
	private lazy var labelAddress = createUILabel()
	private lazy var labelAddressTitle = createUILabel()
	private var isNearest: Bool = false

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
	func reloadData(title: String, address: String) {
		labelTitle.text = title
		labelAddressTitle.text = address
	}
}

// MARK: - Add UIView.
private extension CellForContact {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			labelTitle,
			separator,
			labelAddress,
			labelAddressTitle

		]
		views.forEach(contentView.addSubview)
	}
}

// MARK: - UI configuration.
private extension CellForContact {
	/// Настройка UI элементов
	func setupConfiguration() {
		contentView.backgroundColor = Colors.grey
		contentView.layer.borderWidth = 1
		contentView.layer.borderColor = isNearest ? UIColor.green.cgColor : Theme.mainColor.cgColor
		contentView.layer.cornerRadius = Styles.Radius.radiusTextField
		contentView.clipsToBounds = true
		labelTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		separator.backgroundColor = Theme.mainColor

		labelAddress.text = "Адрес:"
		labelAddress.textAlignment = .left
		labelAddress.font = UIFont.systemFont(ofSize: 14, weight: .regular)

		labelAddressTitle.numberOfLines = 3
		labelAddressTitle.textAlignment = .right
		labelAddressTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
	}
}

// MARK: - Add constraint.
private extension CellForContact {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		let padding = Styles.Padding.self
		NSLayoutConstraint.activate([
			labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
			labelTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding.average),
			labelTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding.average),

			separator.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
			separator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			separator.heightAnchor.constraint(equalToConstant: 2),
			separator.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),

			labelAddress.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
			labelAddress.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding.average),
			labelAddress.rightAnchor.constraint(equalTo: labelAddressTitle.leftAnchor),

			labelAddressTitle.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
			labelAddressTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
			labelAddressTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding.average)
		])
	}
}

// MARK: - UI Fabric.
private extension CellForContact {
	func createUILabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Theme.mainColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createSeparator() -> UIView {
		let separator = UIView()
		separator.translatesAutoresizingMaskIntoConstraints = false
		return separator
	}
}
