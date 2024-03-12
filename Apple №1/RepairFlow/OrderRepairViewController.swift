//
//  OrderRepairViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 05.03.2024.
//

import UIKit

protocol IOrderRepairViewLogic: AnyObject {
	func renderDisplayTitle(modelTitle: String)
	func renderRepairDescription(modelRepairDesc: OrderRepairModel.ViewModel.Repair)
	func renderImage(imageData: Data)
}

// MARK: - OrderRepairViewController
final class OrderRepairViewController: UIViewController {

	// MARK: - Public properties

	// MARK: - Dependencies
	var iterator: IOrderRepairIterator?

	// MARK: - Private properties
	private lazy var labelHeader = createHeader()
	private lazy var labelStep = createLabel()
	private lazy var scrollView = createScrollView()
	private lazy var imageDevice = createImage()
	private lazy var labelTitle = createLabel()
	private lazy var labelDescription = createLabel()
	private lazy var labelPrice = createLabel()
	private lazy var separator = createSeparator()
	private lazy var labelAttention = createLabel()
	private lazy var labelAvailable = createLabel()
	private lazy var buttonRequest = createButton(title: "Оставить заявку на ремонт")
	private lazy var buttonDelivery = createButton(title: "Доставка в Сервис")
	private lazy var buttonCall = createButton(title: "Вызвать мастера")
	private lazy var bonusView = BonusView()

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
		iterator?.fitchDeviceTitle()
		iterator?.fitchRepairDescription()
		iterator?.fitchImage()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		labelHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
		setupLayout()
		reloadScrollView()
		bonusView.transform = CGAffineTransform(rotationAngle: .pi / 6)
	}

	private func reloadScrollView() {
		var paddingScroll: CGFloat = 0
		if view.frame.height <= 700 {
			paddingScroll = 40
		}
		self.scrollView.setNeedsLayout()
		self.scrollView.layoutIfNeeded()
		self.scrollView.contentSize.height = scrollView.frame.size.height + paddingScroll
	}
}

// MARK: - Add UIView.
private extension OrderRepairViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			labelStep,
			scrollView
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension OrderRepairViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		let views: [UIView] = [
			imageDevice,
			labelTitle,
			labelDescription,
			labelPrice,
			separator,
			labelAttention,
			labelAvailable,
			buttonRequest,
			buttonDelivery,
			buttonCall,
			bonusView
		]

		configuratorNavigationBar()
		configureLabel()

		views.forEach(scrollView.addSubview)

		separator.backgroundColor = Colors.grey

		bonusView.translatesAutoresizingMaskIntoConstraints = false

		labelTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)

		labelDescription.font = UIFont.systemFont(ofSize: 16, weight: .medium)
		labelDescription.textColor = Theme.mainColor.withAlphaComponent(0.6)
		labelDescription.numberOfLines = 3

		labelPrice.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		labelPrice.textColor = UIColor.red

		labelAttention.text = "Цена включает работы и материалы!\nТочную стоимость уточняйте в день обращения!"
		labelAttention.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		labelAttention.numberOfLines = 2

		labelAvailable.text = "Запчасти в наличии"
		labelAvailable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		labelAvailable.layer.borderWidth = 2
		labelAvailable.textColor = UIColor.red
		labelAvailable.layer.borderColor = UIColor.red.cgColor
		labelAvailable.layer.cornerRadius = 13

		#warning("TODO: Заменить цвета, на Theme.")
		buttonRequest.backgroundColor = UIColor.gray
		buttonRequest.addTarget(self, action: #selector(requestInRepair), for: .touchUpInside)

		buttonDelivery.backgroundColor = UIColor.gray
		buttonDelivery.addTarget(self, action: #selector(deliveryInService), for: .touchUpInside)

		buttonCall.backgroundColor = UIColor.gray
		buttonCall.addTarget(self, action: #selector(callToRepair), for: .touchUpInside)
	}

	// Настройка navigationBar
	func configuratorNavigationBar() {
		let backButton = UIBarButtonItem()
		backButton.title = "Назад"
		navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
		navigationController?.navigationBar.tintColor = Theme.mainColor

		// Настройка текста в navigationItem.
		labelHeader.text = "Ремонт \n "
		self.navigationItem.titleView = labelHeader
		view.backgroundColor = Theme.backgroundColor
	}

	// Настройка labelStep.
	func configureLabel() {
		labelStep.text = "Заказать ремонт \n 3 шаг из 3"
		labelStep.font = UIFont.boldSystemFont(ofSize: 14.0)
		labelStep.textColor = Theme.mainColor.withAlphaComponent(0.6)
		labelStep.numberOfLines = 2
		labelStep.backgroundColor = Theme.backgroundColor
		labelStep.translatesAutoresizingMaskIntoConstraints = false
	}
}

// MARK: - Add constraint.
private extension OrderRepairViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		let saveAreaTop = view.safeAreaInsets.top
		NSLayoutConstraint.activate([
			labelStep.topAnchor.constraint(equalTo: view.topAnchor, constant: saveAreaTop),
			labelStep.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			labelStep.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			labelStep.heightAnchor.constraint(equalToConstant: 40),

			scrollView.topAnchor.constraint(equalTo: labelStep.bottomAnchor, constant: 10),
			scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),

			imageDevice.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
			imageDevice.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			imageDevice.heightAnchor.constraint(equalToConstant: 120),
			imageDevice.widthAnchor.constraint(equalToConstant: 120),

			labelTitle.topAnchor.constraint(equalTo: imageDevice.bottomAnchor, constant: 10),
			labelTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			labelTitle.heightAnchor.constraint(equalToConstant: 20),
			labelTitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

			labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
			labelDescription.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			labelDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

			labelPrice.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 10),
			labelPrice.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			labelPrice.heightAnchor.constraint(equalToConstant: 20),
			labelPrice.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

			separator.topAnchor.constraint(equalTo: labelPrice.bottomAnchor, constant: 10),
			separator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			separator.heightAnchor.constraint(equalToConstant: 2),
			separator.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),

			labelAttention.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
			labelAttention.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			labelAttention.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),

			labelAvailable.topAnchor.constraint(equalTo: labelAttention.bottomAnchor, constant: 10),
			labelAvailable.rightAnchor.constraint(equalTo: labelPrice.rightAnchor, constant: 0),
			labelAvailable.heightAnchor.constraint(equalToConstant: 26),
			labelAvailable.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.4),

			buttonRequest.topAnchor.constraint(equalTo: labelAttention.bottomAnchor, constant: 50),
			buttonRequest.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			buttonRequest.heightAnchor.constraint(equalToConstant: 40),
			buttonRequest.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

			buttonDelivery.topAnchor.constraint(equalTo: buttonRequest.bottomAnchor, constant: 16),
			buttonDelivery.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			buttonDelivery.heightAnchor.constraint(equalToConstant: 40),
			buttonDelivery.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

			buttonCall.topAnchor.constraint(equalTo: buttonDelivery.bottomAnchor, constant: 16),
			buttonCall.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			buttonCall.heightAnchor.constraint(equalToConstant: 40),
			buttonCall.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

			bonusView.centerYAnchor.constraint(equalTo: imageDevice.centerYAnchor),
			bonusView.rightAnchor.constraint(equalTo: labelTitle.rightAnchor),
			bonusView.widthAnchor.constraint(equalToConstant: 100),
			bonusView.heightAnchor.constraint(equalToConstant: 45)
		])
	}
}

// MARK: - UI Fabric.
private extension OrderRepairViewController {
	func createImage() -> UIImageView {
		let image = UIImage(named: "IconDevices/emptyImageDevices")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	func createLabel() -> UILabel {
		let label = UILabel()
		label.textColor = Theme.mainColor
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createHeader() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 2
		label.font = UIFont.boldSystemFont(ofSize: 18.0)
		label.textColor = Theme.mainColor
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createButton(title: String) -> UIButton {
		let button = UIButton()
		button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		button.setTitle(title, for: .normal)
		button.setTitleColor(Theme.backgroundColor, for: .normal)
		button.layer.cornerRadius = Styles.Radius.radiusTextField
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}

	func createSeparator() -> UIView {
		let separator = UIView()
		separator.translatesAutoresizingMaskIntoConstraints = false
		return separator
	}

	func createScrollView() -> UIScrollView {
		let scroll = UIScrollView()
		scroll.showsVerticalScrollIndicator = false
		scroll.alwaysBounceVertical = false
		scroll.translatesAutoresizingMaskIntoConstraints = false
		return scroll
	}
}

// MARK: - UI Action.
private extension OrderRepairViewController {
	@objc func requestInRepair() {
		print("Request in repair.")
	}

	@objc func deliveryInService() {
		print("Delivery in service.")
	}

	@objc func callToRepair() {
		print("Calling to master.")
	}
}

// MARK: - Render logic.
extension OrderRepairViewController: IOrderRepairViewLogic {
	func renderDisplayTitle(modelTitle: String) {
		labelHeader.text = "Ремонт \n\(modelTitle)"
	}

	func renderRepairDescription(modelRepairDesc: OrderRepairModel.ViewModel.Repair) {
		labelTitle.text = modelRepairDesc.title
		labelDescription.text = modelRepairDesc.description
		labelPrice.text = modelRepairDesc.price
		if !modelRepairDesc.available {
			labelAvailable.isHidden = true
		}
	}

	func renderImage(imageData: Data) {
		let image = UIImage(data: imageData)
		imageDevice.image = image
	}
}
