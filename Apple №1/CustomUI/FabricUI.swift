//
//  FabricUI.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import UIKit
// отключить тут translatesAutoresizingMaskIntoConstraints и у место иниуиализации запихать
//  переписать в enum  и статические методы
/// Шаблоны ``UIView``
final class FabricUI {

	// MARK: - Private properties
	private static let zero = Styles.Padding.zero

	/// Шаблон для создания текста
	/// - Returns: ``UILabel``
	/// - Note: В настройке - выравнивание и количество строк
	func createLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Theme.mainColor
		label.numberOfLines = 1
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}

	/// Шаблон для создания изображения.
	/// - Parameters:
	///   - image: Ссылка на изображение из Assets
	/// - Returns: ``UIImageView``
	func createImage(_ image: String) -> UIImageView {
		let image = UIImage(named: image)
		let imageView = UIImageView(image: image)
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	func createSystemImage(_ image: String) -> UIImageView {
		let image = UIImage(systemName: image)
		let imageView = UIImageView(image: image)
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	/// Шаблон для создания текстового поля.
	/// - Returns: ``UITextField``
	/// - Note: В настройке - цвет (фона, текста, tint), скругление, шрифт,
	///  правый и левый отступ (по умолчанию 20)
	func createTextField(_ placeholder: String) -> UITextField {
		let textField = UITextField()
		textField.backgroundColor = Theme.accentColor
		textField.keyboardType = .numberPad
		textField.textColor = Theme.mainColor
		textField.tintColor = Theme.mainColor
		textField.layer.cornerRadius = Styles.Radius.radiusTextField
		textField.layer.borderColor = Theme.mainColor.cgColor
		textField.layer.borderWidth = Styles.Border.one
		textField.setLeftPadding(Styles.Padding.average)
		textField.setRightPadding(Styles.Padding.average)
		textField.attributedPlaceholder = NSAttributedString(
			string: placeholder,
			attributes: [NSAttributedString.Key.foregroundColor: Theme.mainColor]
		)
		textField.translatesAutoresizingMaskIntoConstraints = false

		return textField
	}

	/// Шаблон для создания кнопки с системным изображением.
	/// - Returns: ``UIButton``
	/// - Note: В настройке - системное изображение, размер изображения, отступ, цвет
	func createButtonWithImage(_ name: String, _ size: CGFloat) -> UIButton {
		let button = UIButton()
		let configuration = UIImage.SymbolConfiguration(pointSize: size)
		let image = UIImage(systemName: name, withConfiguration: configuration)
		button.setImage(image, for: .normal)
		button.tintColor = Theme.mainColor
		button.imageEdgeInsets = UIEdgeInsets(
			top: FabricUI.zero,
			left: -Styles.Padding.average,
			bottom: FabricUI.zero,
			right: FabricUI.zero
		)
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	/// Шаблон для создания кнопки текстом и с системным изображением.
	/// - Returns: ``UIButton``
	/// - Note: В настройке - системное изображение, размер изображения, отступ, цвет
	func createButtonTextWithImage() -> UIButton {
		let button = UIButton(frame: .zero)
		button.setTitle("Model iPhone 13", for: .normal)
		button.setTitleColor(UIColor.red, for: .normal)
		button.setImage(UIImage(systemName: "pencil.slash"), for: .normal)
		button.tintColor = UIColor.red
		button.backgroundColor = .white
		button.imageEdgeInsets.left = 20

		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	/// Шаблон для создания кнопки без изображения.
	/// - Returns: ``UIButton``
	/// - Note: В настройке - цвет, шрифт, радиус скругление.
	func createButton(_ title: String) -> UIButton {
		let button = UIButton()
		button.backgroundColor = UIColor.red
		button.titleLabel?.font = UIFont.systemFont(ofSize: Styles.Fonts.average, weight: .semibold)
		button.setTitleColor(Theme.mainColor, for: .normal)
		button.setTitle(title, for: .normal)
		button.layer.cornerRadius = Styles.Radius.radiusTextField
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	/// Шаблон для стека.
	/// - Returns: ``UIStackView``
	/// - Note: В настройке - направление, заполнение, выравнивание
	func vStack(_ view: [UIView]) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: view)
		stack.axis = .vertical
		stack.distribution = .fillProportionally
		stack.alignment = .trailing
		stack.translatesAutoresizingMaskIntoConstraints = false

		return stack
	}

	/// Шаблон сепаратора
	/// - Returns: ``UIView``
	/// - Note: В настройке - цвет
	func createSeparator() -> UIView {
		let separator = UIView()
		separator.backgroundColor = UIColor.red
		separator.translatesAutoresizingMaskIntoConstraints = false

		return separator
	}

	func createTabView() -> UITableView {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}

	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func forContactsList() -> UIBarButtonItem {
		let image = UIImage(systemName: "arrow.left")
		let backButton = UIBarButtonItem()
		backButton.image = image
		backButton.style = .plain
		backButton.tintColor = .white

		return backButton

	}

	func createCollectionView(direction: UICollectionView.ScrollDirection) -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = direction
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		return collectionView
	}
}

extension UITextField {
	/// Левый отступ
	/// - Parameters:
	///   - amount: Значение отступа
	func setLeftPadding(_ amount: CGFloat) {
		let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
		self.leftView = padding
		self.leftViewMode = .always
	}

	/// Правый отступ
	/// - Parameters:
	///   - amount: Значение отступа
	func setRightPadding(_ amount: CGFloat) {
		let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
		self.rightView = padding
		self.rightViewMode = .always
	}
}
