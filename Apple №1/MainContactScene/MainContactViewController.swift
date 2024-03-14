//
//  MainContactViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 16.01.2024.
//

import UIKit

protocol IMainContactViewLogic: AnyObject {
	func renderAddresses(renderAddress: [MainContactModel.ViewModel.AddressWorkShop])
	func renderCurrentLocation(renderCurrentLocation: MainContactModel.ViewModel.Coordinates)
	func renderDistance(renderDistance: Double)
}

final class MainContactViewController: UIViewController {

	// MARK: - Dependencies
	var iterator: IMainContactIterator?

	// MARK: - Private properties
	private var mapView = MapView()
	private lazy var labelHeader = createLabel()
	private lazy var labelDistance = createLabel()
	private lazy var collectionAddress = createCollectionView()
	private lazy var buttonMyLocation = createButton(systemName: "location")
	private lazy var buttonIncrease = createButton(systemName: "plus.magnifyingglass")
	private lazy var buttonDecrease = createButton(systemName: "minus.magnifyingglass")
	private var modelCurrentLocation = MainContactModel.ViewModel.Coordinates(latitude: 0.0, longitude: 0.0)
	private var modelForDisplay: [MainContactModel.ViewModel.AddressWorkShop] = []
	private var modelForDisplayMap: MainContactModel.Request.Coordinates = MainContactModel.Request.Coordinates(
		latitude: 0.0,
		longitude: 0.0,
		zoom: 0,
		flag: MainContactModel.Request.FlagCoordinates(latitude: 0.0, longitude: 0.0)
	)
	private var currentZoom: Float = 12.0 {
		willSet {
			modelForDisplayMap.zoom = newValue
		}
	}

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
		iterator?.fitchAddresses()
		iterator?.fitchCurrentLocation()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
		labelHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
	}
}

// MARK: - Add UIView.
private extension MainContactViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			collectionAddress,
			labelDistance,
			mapView,
			buttonMyLocation,
			buttonIncrease,
			buttonDecrease
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension MainContactViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		// Настройка текста в navigationItem.
		labelHeader.text = "Контакты\n"
		self.navigationItem.titleView = labelHeader
		view.backgroundColor = Theme.backgroundColor

		collectionAddress.backgroundColor = Theme.backgroundColor
		collectionAddress.showsHorizontalScrollIndicator = false
		collectionAddress.register(CellForContact.self, forCellWithReuseIdentifier: CellForContact.reuseIdentifier)
		collectionAddress.delegate = self
		collectionAddress.dataSource = self

		labelDistance.text = "Расстояние до текущего центра - 45656 км"
		labelDistance.numberOfLines = 2
		labelDistance.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		labelDistance.layer.borderWidth = 1

		mapView.layer.borderWidth = 1
		mapView.layer.cornerRadius = Styles.Radius.radiusTextField
		mapView.clipsToBounds = true
		mapView.translatesAutoresizingMaskIntoConstraints = false

		buttonMyLocation.addTarget(self, action: #selector(myLocation), for: .touchUpInside)
		buttonIncrease.addTarget(self, action: #selector(increaseMap), for: .touchUpInside)
		buttonDecrease.addTarget(self, action: #selector(decreaseMap), for: .touchUpInside)

	}
}

// MARK: - Add constraint.
private extension MainContactViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		let saveAreaTop = view.safeAreaInsets.top
		NSLayoutConstraint.activate([
			collectionAddress.topAnchor.constraint(equalTo: view.topAnchor, constant: saveAreaTop),
			collectionAddress.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			collectionAddress.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			collectionAddress.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

			labelDistance.topAnchor.constraint(equalTo: collectionAddress.bottomAnchor, constant: 10),
			labelDistance.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			labelDistance.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			labelDistance.heightAnchor.constraint(equalToConstant: 40),

			mapView.topAnchor.constraint(equalTo: labelDistance.bottomAnchor, constant: 10),
			mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),

			buttonMyLocation.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -10),
			buttonMyLocation.bottomAnchor.constraint(equalTo: buttonIncrease.topAnchor, constant: -25),
			buttonMyLocation.heightAnchor.constraint(equalToConstant: 40),
			buttonMyLocation.widthAnchor.constraint(equalToConstant: 40),

			buttonIncrease.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -10),
			buttonIncrease.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -30),
			buttonIncrease.heightAnchor.constraint(equalToConstant: 40),
			buttonIncrease.widthAnchor.constraint(equalToConstant: 40),

			buttonDecrease.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -10),
			buttonDecrease.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: 30),
			buttonDecrease.heightAnchor.constraint(equalToConstant: 40),
			buttonDecrease.widthAnchor.constraint(equalToConstant: 40)

		])
	}
}

// MARK: - CollectionView Layout.
extension MainContactViewController: UICollectionViewDelegateFlowLayout {
	// Настройка размеров ячейки.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
	}
}

// MARK: - CollectionView Source and Delegate.
extension MainContactViewController: UICollectionViewDataSource, UIColorPickerViewControllerDelegate {
	// Действие по клику на ячейку.
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let currentLocation = modelForDisplay[indexPath.row]
		self.currentZoom = 12
		modelForDisplayMap = MainContactModel.Request.Coordinates(
			latitude: currentLocation.coordinate.latitude,
			longitude: currentLocation.coordinate.longitude,
			zoom: currentZoom,
			flag: MainContactModel.Request.FlagCoordinates(
				latitude: currentLocation.flag.latitude,
				longitude: currentLocation.flag.longitude
			)
		)
		iterator?.fitchDistance(
			currentCoordinate: CoordinateR(
				latitude: modelCurrentLocation.latitude,
				longitude: modelCurrentLocation.longitude
			),
			coordinate: CoordinateR(
				latitude: modelForDisplayMap.latitude,
				longitude: modelForDisplayMap.longitude
			)
		)
		getMap()
	}

	// Количество ячеек.
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		modelForDisplay.count
	}

	func collectionView(
		_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let address = modelForDisplay[indexPath.row]
		let cell = collectionAddress.dequeueReusableCell(
			withReuseIdentifier: CellForContact.reuseIdentifier, for: indexPath
		)
		if let currentCell = cell as? CellForContact {
			currentCell.reloadData(title: address.title, address: address.address)
			return currentCell
		}
		return UICollectionViewCell()
	}
}

// MARK: - UI Fabric.
private extension MainContactViewController {
	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createLabel() -> UILabel {
		let label = UILabel()
		label.textColor = Theme.mainColor
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}

	func createImage() -> UIImageView {
		let image = UIImage(named: "IconDevices/MacPro")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	func createButton(systemName: String) -> UIButton {
		let button = UIButton()
		let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
		let image = UIImage(systemName: systemName, withConfiguration: configuration)
		button.setImage(image, for: .normal)
		button.backgroundColor = UIColor.gray
		button.tintColor = UIColor.white
		button.layer.borderWidth = 2
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.cornerRadius = 20
		button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}
}

// MARK: - UI Action.
private extension MainContactViewController {
	@objc func increaseMap() {
		currentZoom += 1
		if currentZoom >= 21 {
			currentZoom = 21
		}
		getMap()
	}

	@objc func decreaseMap() {
		currentZoom -= 1
		if currentZoom <= 0 {
			currentZoom = 0
		}
		getMap()
	}

	@objc func myLocation() {

	}

	func getMap() {
		mapView.reload(coordinate: modelForDisplayMap)
	}
}

// MARK: - Render logic.
extension MainContactViewController: IMainContactViewLogic {
	func renderAddresses(renderAddress: [MainContactModel.ViewModel.AddressWorkShop]) {
		self.modelForDisplay = renderAddress
		self.collectionAddress.reloadData()
		if let firstElement = self.modelForDisplay.first {
			modelForDisplayMap = MainContactModel.Request.Coordinates(
				latitude: firstElement.coordinate.latitude,
				longitude: firstElement.coordinate.longitude,
				zoom: currentZoom,
				flag: MainContactModel.Request.FlagCoordinates(
					latitude: firstElement.flag.latitude,
					longitude: firstElement.flag.longitude
				)
			)
		}
		getMap()
	}

	func renderCurrentLocation(renderCurrentLocation: MainContactModel.ViewModel.Coordinates) {
		modelCurrentLocation = renderCurrentLocation
		iterator?.fitchDistance(
			currentCoordinate: CoordinateR(
				latitude: modelCurrentLocation.latitude,
				longitude: modelCurrentLocation.longitude
			),
			coordinate: CoordinateR(
				latitude: modelForDisplayMap.latitude,
				longitude: modelForDisplayMap.longitude
			)
		)
	}

	func renderDistance(renderDistance: Double) {
		labelDistance.text = "Расстояние до текущего центра - \(renderDistance) км"
	}
}
