//
//  CellForDevices.swift
//  Apple №1
//
//  Created by Steven Kirke on 28.01.2024.
//

import UIKit

// MARK: - Class CellForDevices
final class CellForDevices: UICollectionViewCell {

	// MARK: - Public properties
	static let reuseIdentifier = "CellForDevices.cell"

	// MARK: - Private properties
	private lazy var imageDevice = createImage()

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

	// MARK: - Private methods
	func render(image: UIImage) {
		imageDevice.image = image
	}
}

// - MARK: Add UIView in Controler
private extension CellForDevices {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			imageDevice
		]
		views.forEach(contentView.addSubview)
	}
}

// - MARK: Initialisation configuration
private extension CellForDevices {
	/// Настройка UI элементов
	func setupConfiguration() {
		contentView.backgroundColor = Colors.grey
		contentView.layer.borderWidth = 1
		contentView.layer.cornerRadius = Styles.Radius.radiusTextField
	}
}

// - MARK: Initialisation constraint elements.
private extension CellForDevices {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			imageDevice.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageDevice.leftAnchor.constraint(equalTo: contentView.leftAnchor),
			imageDevice.rightAnchor.constraint(equalTo: contentView.rightAnchor),
			imageDevice.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}

// MARK: - UI Fabric.
private extension CellForDevices {
	func createImage() -> UIImageView {
		let image = UIImage(named: "IconDevices/iMac")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 10
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}
}
