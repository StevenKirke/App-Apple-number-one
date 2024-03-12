//
//  HeaderForSeries.swift
//  Apple №1
//
//  Created by Steven Kirke on 05.02.2024.
//

import UIKit

/// Обработчик нажатия на кнопку.
protocol IHeaderSeriesHandler: AnyObject {
	/// Возвращаем текущую секцию, Collection View.
	func returnIndexPath(section: Int, resultTest: (Bool) -> Void)
}

// MARK: - Class SectionHeaderForModelCell
final class HeaderForSeries: UICollectionReusableView {

	// MARK: - Dependencies
	var handlerButtonDelegate: IHeaderSeriesHandler?

	// MARK: - Public properties
	static let identifierHeader = "headerForSeries.header"

	// MARK: - Private properties
	private lazy var imageButton = createImage()
	private lazy var buttonShowCell = createButton()
	private var currentSection: Int?

	// MARK: - Initializator
	convenience init(handlerButtonDelegate: IHeaderSeriesHandler?) {
		self.init(frame: CGRect.zero)
		self.handlerButtonDelegate = handlerButtonDelegate
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		addUIView()
		setupConfiguration()
		setupLayout()
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}

	// MARK: - Public methods
	func render(title: String, section: Int) {
		self.currentSection = section
		self.buttonShowCell.setTitle(title, for: .normal)
	}
}

// MARK: - Add UIView.
private extension HeaderForSeries {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			buttonShowCell,
			imageButton
		]
		views.forEach(addSubview)
	}
}

// MARK: - UI configuration.
private extension HeaderForSeries {
	/// Настройка UI элементов
	func setupConfiguration() {
		buttonShowCell.layer.borderWidth = 1
		buttonShowCell.tintColor = Theme.mainColor
		buttonShowCell.backgroundColor = Colors.grey
		buttonShowCell.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)

		imageButton.tintColor = Theme.mainColor
	}
}

// MARK: - Add constraint.
private extension HeaderForSeries {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		let padding = Styles.Padding.self
		NSLayoutConstraint.activate([
			buttonShowCell.topAnchor.constraint(equalTo: self.topAnchor),
			buttonShowCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding.average),
			buttonShowCell.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding.average),
			buttonShowCell.bottomAnchor.constraint(equalTo: self.bottomAnchor),

			imageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			imageButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -(padding.average + 10)),
			imageButton.widthAnchor.constraint(equalToConstant: 28),
			imageButton.heightAnchor.constraint(equalToConstant: 28)
		])
	}
}

// MARK: - UI Fabric.
private extension HeaderForSeries {
	func createImage() -> UIImageView {
		let configurator = UIImage.SymbolConfiguration(textStyle: .title1)
		let image = UIImage(systemName: "chevron.left", withConfiguration: configurator)
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	/// Создание UIButton, с преобразованием изменения размера.
	func createButton() -> UIButton {
		let button = UIButton()
		button.backgroundColor = Theme.backgroundColor
		button.titleLabel?.font = UIFont.systemFont(ofSize: Styles.Fonts.average, weight: .semibold)
		button.setTitleColor(Theme.mainColor, for: .normal)
		button.layer.cornerRadius = Styles.Radius.radiusTextField
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}
}

// MARK: - UI Action.
private extension HeaderForSeries {
	@objc func buttonTap() {
		guard let section = self.currentSection else { return }
		self.handlerButtonDelegate?.returnIndexPath(section: section) { result in
			switch result {
			case true:
				self.buttonShowCell.tintColor = UIColor.green
			case false:
				self.buttonShowCell.tintColor = UIColor.red
			}
		}
	}
}
