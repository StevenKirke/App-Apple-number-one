//
//  MainRepairViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

// MARK: - Protocol.
protocol IMainRepairViewLogic: AnyObject {
	/// Отображение данный модели MainRepairDevicesModel.ViewModel.Device
	func renderDevices(viewModel: [MainRepairDevicesModel.ViewModel.Device])

	/// Отображение данный модели MainRepairDevicesModel.ViewModel.Device
	func renderSeries(viewModel: [MainRepairSeriesModel.ViewModel.Series])
}

// MARK: - MainRepairViewController
final class MainRepairViewController: UIViewController {

	// MARK: - Dependencies
	var iterator: IMainRepairIterator?
	var hendlerCellModelDelegate: ISeriesCellHandler?

	// MARK: - Private properties
	private lazy var labelHeader = createHeader()
	private lazy var labelStep = createHeader()
	private lazy var collectionDevices = DevicesCollectionView()
	private lazy var collectionSeries = SeriesCollectionView()
	private var currentDeviceID = MainRepairSeriesModel.RequestSeries.Devices(
		deviceID: 0,
		parentID: 0,
		title: ""
	)

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
		iterator?.fetchDevices()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
		labelHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
	}
}

// MARK: - Add UIView.
private extension MainRepairViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			labelStep,
			collectionDevices,
			collectionSeries
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension MainRepairViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		// Настройка текста в navigationItem.
		labelHeader.text = "Ремонт \n"
		self.navigationItem.titleView = labelHeader
		view.backgroundColor = Theme.backgroundColor

		configureLabel()

		// Настройки коллекции серии устройств.
		collectionDevices.translatesAutoresizingMaskIntoConstraints = false
		collectionDevices.handlerTitleDelegate = self

		// Настройки коллекции серии устройств и моделей.
		collectionSeries.translatesAutoresizingMaskIntoConstraints = false
		collectionSeries.handlerSeriesCellDelegate = self
	}

	// Настройка labelStep.
	func configureLabel() {
		labelStep.text = "Выберите устройство и модель \n 1 шаг из 3"
		labelStep.font = UIFont.boldSystemFont(ofSize: 14.0)
		labelStep.textColor = Theme.mainColor.withAlphaComponent(0.6)
		labelStep.numberOfLines = 2
		labelStep.translatesAutoresizingMaskIntoConstraints = false
	}
}

// MARK: - Add constraint.
private extension MainRepairViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		let saveAreaTop = view.safeAreaInsets.top
		NSLayoutConstraint.activate([
			labelStep.topAnchor.constraint(equalTo: view.topAnchor, constant: saveAreaTop),
			labelStep.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			labelStep.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			labelStep.heightAnchor.constraint(equalToConstant: 40),
			// Настройка отображения горизонтального CollectionView.
			collectionDevices.topAnchor.constraint(equalTo: labelStep.bottomAnchor, constant: 10),
			collectionDevices.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			collectionDevices.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			collectionDevices.heightAnchor.constraint(equalToConstant: 130),
			// Настройка отображения вертикального CollectionView.
			collectionSeries.topAnchor.constraint(equalTo: collectionDevices.bottomAnchor, constant: 20),
			collectionSeries.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionSeries.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionSeries.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

// MARK: - UI Fabric.
private extension MainRepairViewController {
	func createHeader() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 2
		label.font = UIFont.boldSystemFont(ofSize: 18.0)
		label.textColor = Theme.mainColor
		label.textAlignment = .center
		return label
	}
}

// MARK: - Render
extension MainRepairViewController: IMainRepairViewLogic {
	func renderDevices(viewModel: [MainRepairDevicesModel.ViewModel.Device]) {
		if let firstDevice = viewModel.first {
			currentDeviceID.deviceID = firstDevice.id
			currentDeviceID.title = firstDevice.title
			uploadLabel()
		}
		collectionDevices.reloadModel(model: viewModel)
		iterator?.fetchSeriesAndModel(device: currentDeviceID)
	}

	func renderSeries(viewModel: [MainRepairSeriesModel.ViewModel.Series]) {
		collectionSeries.reloadModel(model: viewModel)
	}
}

// MARK: - Update View.
private extension MainRepairViewController {
	func uploadLabel() {
		labelHeader.text = "Ремонт \n\(currentDeviceID.title)"
	}
}

// MARK: - Delegate.
extension MainRepairViewController: IDevicesCollectionCellHandler {
	func returnTitle(title: String, deviceID: Int) {
		self.currentDeviceID.deviceID = deviceID
		self.currentDeviceID.title = title
		uploadLabel()
		iterator?.fetchSeriesAndModel(device: currentDeviceID)
	}
}

// MARK: - Logic.
extension MainRepairViewController: ISeriesCellHandler {
	func returnModel(modelDevice: MainRepairSeriesModel.ViewModel.Model) {
		let id = Int(modelDevice.id) ?? 0
		let parentID = Int(modelDevice.parentID) ?? 0
		let model = MainRepairSeriesModel.RequestSeries.Devices(
			deviceID: id,
			parentID: parentID,
			title: modelDevice.title
		)
		iterator?.nextScene(device: model)
	}
}
