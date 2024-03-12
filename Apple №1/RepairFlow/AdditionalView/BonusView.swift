//
//  BonusView.swift
//  Apple №1
//
//  Created by Steven Kirke on 09.03.2024.
//

import UIKit

// MARK: - BonusView
final class BonusView: UIView {

	// MARK: - Public properties

	// MARK: - Dependencies

	// MARK: - Private properties
	private lazy var viewFrame = createView()
	private lazy var labelTitle = createLabel()
	private lazy var labelBonus = createLabel()

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
	func reloadData() { }
}

// MARK: - Add UIView.
private extension BonusView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			viewFrame,
			labelTitle,
			labelBonus
		]
		views.forEach(addSubview)
	}
}

// MARK: - UI configuration.
private extension BonusView {
	/// Настройка UI элементов
	func setupConfiguration() {
		viewFrame.layer.borderWidth = 2
		viewFrame.layer.cornerRadius = Styles.Radius.radiusTextField
		viewFrame.layer.borderColor = UIColor.red.cgColor

		labelTitle.text = "Бонусов"
		labelBonus.text = "65149"
	}
}

// MARK: - Add constraint.
private extension BonusView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			viewFrame.topAnchor.constraint(equalTo: self.topAnchor),
			viewFrame.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			viewFrame.leftAnchor.constraint(equalTo: self.leftAnchor),
			viewFrame.rightAnchor.constraint(equalTo: self.rightAnchor),

			labelTitle.topAnchor.constraint(equalTo: viewFrame.topAnchor, constant: 4),
			labelTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
			labelTitle.rightAnchor.constraint(equalTo: self.rightAnchor),

			labelBonus.bottomAnchor.constraint(equalTo: viewFrame.bottomAnchor, constant: -4),
			labelBonus.leftAnchor.constraint(equalTo: self.leftAnchor),
			labelBonus.rightAnchor.constraint(equalTo: self.rightAnchor)
		])
	}
}

// MARK: - YourClass Layout.
extension BonusView { }

// MARK: - YourClass Source and Delegate.
extension BonusView { }

// MARK: - UI Fabric.
private extension BonusView {
	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createLabel() -> UILabel {
		let label = UILabel()
		label.textColor = UIColor.red
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}

// MARK: - UI Action.
private extension BonusView { }
// MARK: - Render logic.
private extension BonusView { }
