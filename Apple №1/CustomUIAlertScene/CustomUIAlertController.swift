//
//  CustomUIAlertController.swift
//  Apple №1
//
//  Created by Steven Kirke on 06.01.2024.
//

import UIKit

protocol ICustomUIAlertProtocol {
	/// Показ окна CustomUIAlert.
	/// - Parameters:
	///   - AlertMassageType.successBlock: Отображение окна подтверждения положительного запроса.
	///  Например: Вызов мастера/курьера.
	///   - AlertMassageType.errorBlock: Отображение окна ошибки, входящий параметр 'massage' - описание ошибки.
	/// - Note: Отображение кастомного UIAlertView
	func show(typeMassage: AlertMassageType)
}

final class CustomUIAlertController: UIViewController {

	private enum AlertStyle {
		/// 300
		static let width: CGFloat = 300
		/// 182
		static let height: CGFloat = 182
		/// 60
		static let sizeCircle: CGFloat = 60
		/// 77
		static let widthButton: CGFloat = 100
		/// 23
		static let heightButton: CGFloat = 29
	}

	// MARK: - Private properties
	private lazy var alertView = createView()
	private lazy var labelTitle = createLabel()
	private lazy var labelDescription = createLabel()
	private lazy var labelErrorTitle = createLabel()
	private lazy var okButton = createButton(modelForDisplay.buttonTitle)
	private lazy var imageEmoji = createLabel()
	private lazy var separator = createView()
	private lazy var circleView = createView()
	private lazy var maskView = createView()

	private var modelForDisplay: AlertMassageType.Description = .init(from: AlertMassageType.successBlock)

	// MARK: - Initializator
	init() {
		super.init(nibName: nil, bundle: nil)
		self.modalPresentationStyle = .overCurrentContext
		self.modalTransitionStyle = .crossDissolve
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		addUI()
		setupConfiguration()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
	}
}

// MARK: - Add UIView.
private extension CustomUIAlertController {
	/// Добавление элементов в 'SignInViewController'
	func addUI() {
		let views: [UIView] = [
			alertView, circleView,
			maskView, imageEmoji,
			labelTitle, separator,
			labelDescription, labelErrorTitle,
			okButton
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension CustomUIAlertController {
	/// Настройка UI элементов
	func setupConfiguration() {
		view.backgroundColor = UIColor.clear

		// Настройка контейнера CustomUIAlertController.
		alertView.backgroundColor = Theme.backgroundColor
		alertView.layer.cornerRadius = Styles.Radius.radiusTextField
		alertView.layer.borderWidth = Styles.Border.one
		alertView.layer.borderColor = Theme.accentColor.cgColor

		// Настройка круглого фона для изображения Emoji.
		circleView.backgroundColor = Theme.backgroundColor
		circleView.layer.cornerRadius = Styles.Heights.sixty / 2
		circleView.layer.borderWidth = Styles.Border.one
		circleView.layer.borderColor = Theme.accentColor.cgColor

		// Настройка маски для скрытия фона для изображения
		maskView.backgroundColor = Theme.backgroundColor

		// Настройка основного текста.
		labelTitle.text = modelForDisplay.title
		labelTitle.textColor = Theme.mainColor
		labelTitle.textAlignment = .center
		labelTitle.font = UIFont.systemFont(ofSize: Styles.Fonts.big, weight: .medium)

		// Настройка label описания.
		labelDescription.text = modelForDisplay.subTitle
		labelDescription.textColor = Theme.mainColor
		labelDescription.textAlignment = .center
		labelDescription.font = UIFont.systemFont(ofSize: Styles.Fonts.small, weight: .regular)

		// Настройка label описание ошибки, передача String ошибки.
		labelErrorTitle.text = modelForDisplay.errorDescription
		labelErrorTitle.font = UIFont.systemFont(ofSize: Styles.Fonts.little, weight: .regular)
		labelErrorTitle.numberOfLines = 2
		labelErrorTitle.textColor = Theme.mainColor
		labelErrorTitle.layer.borderWidth = 1

		imageEmoji.text = modelForDisplay.imageEmoji
		imageEmoji.font = UIFont.systemFont(ofSize: Styles.Fonts.fortyFour, weight: .regular)

		okButton.setTitleColor(Theme.mainColor, for: .normal)
		okButton.backgroundColor = Theme.accentColor
		okButton.layer.cornerRadius = Styles.Radius.radiusTextField

		separator.backgroundColor = Theme.mainColor
		separator.layer.cornerRadius = Styles.Radius.radiusOne

		// Добавление action: Закрыть окно CustomUIAlertControlle
		okButton.addTarget(self, action: #selector(closeAlertView), for: .touchUpInside)
	}
}

// MARK: - Add constraint.
private extension CustomUIAlertController {
	/// Верстка элементов UI
	func setupLayout() {
		let padding = Styles.Padding.self
		NSLayoutConstraint.activate([
			// Настройка контейнера UIAlertView.
			alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			alertView.widthAnchor.constraint(equalToConstant: AlertStyle.width),
			alertView.heightAnchor.constraint(equalToConstant: AlertStyle.height),

			// Настройка заднего фона для изображения.
			circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			circleView.widthAnchor.constraint(equalToConstant: AlertStyle.sizeCircle),
			circleView.heightAnchor.constraint(equalToConstant: AlertStyle.sizeCircle),
			circleView.bottomAnchor.constraint(equalTo: alertView.topAnchor, constant: AlertStyle.sizeCircle / 2),

			// Настройка маски, которая прячет часть круглого фона для изображения.
			maskView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
			maskView.widthAnchor.constraint(equalToConstant: AlertStyle.sizeCircle),
			maskView.heightAnchor.constraint(equalToConstant: AlertStyle.sizeCircle / 2),
			maskView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: .zero),

			// Настройка названия.
			labelTitle.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
			labelTitle.heightAnchor.constraint(equalToConstant: Styles.Heights.thirty),
			labelTitle.topAnchor.constraint(equalTo: alertView.topAnchor, constant: Styles.Heights.twenty),
			labelTitle.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Styles.Padding.average),
			labelTitle.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Styles.Padding.average),

			// Настройка label описания, происходящего действия.
			labelDescription.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
			labelDescription.heightAnchor.constraint(equalToConstant: Styles.Heights.twenty),
			labelDescription.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: padding.average),
			labelDescription.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -padding.average),
			labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: Styles.Heights.fourteen),

			// Настройка label ошибки, если она существует.
			labelErrorTitle.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
			labelErrorTitle.heightAnchor.constraint(equalToConstant: Styles.Heights.thirty),
			labelErrorTitle.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: padding.average),
			labelErrorTitle.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -padding.average),
			labelErrorTitle.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: padding.little),

			// Настройка изображения.
			imageEmoji.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
			imageEmoji.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),

			// Настройка кнопки "OK".
			okButton.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
			okButton.heightAnchor.constraint(equalToConstant: AlertStyle.heightButton),
			okButton.widthAnchor.constraint(equalToConstant: AlertStyle.widthButton),
			okButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -Styles.Heights.fifteen),

			// Настройка сепаратора.
			separator.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
			separator.heightAnchor.constraint(equalToConstant: Styles.Heights.two),
			separator.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Styles.Padding.average),
			separator.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Styles.Padding.average),
			separator.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: Styles.Heights.six)
		])
	}
}

// MARK: - UI Fabric.
private extension CustomUIAlertController {
	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}

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
}

// - MARK: Action UI
private extension CustomUIAlertController {
	@objc func closeAlertView() {
		self.dismiss(animated: true, completion: nil)
	}
}

extension CustomUIAlertController: ICustomUIAlertProtocol {
	func show(typeMassage: AlertMassageType) {
		switch typeMassage {
		case .successBlock:
			modelForDisplay = .init(from: .successBlock)
		case .errorBlock(let massage):
			modelForDisplay = .init(from: .errorBlock(massage: massage))
		}
	}
}
