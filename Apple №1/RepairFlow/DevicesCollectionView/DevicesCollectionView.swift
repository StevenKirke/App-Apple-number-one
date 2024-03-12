//
//  DevicesCollectionView.swift
//  Apple №1
//
//  Created by Steven Kirke on 07.02.2024.
//

import UIKit

protocol IDevicesCollectionCellHandler: AnyObject {
	/// Возвращаем название типа устройства, и его ID.
	/// Для дальнейшего запроса серии и моделей.
	func returnTitle(title: String, deviceID: Int)
}

// MARK: - Class DevicesCollectionView
final class DevicesCollectionView: UIView {

	// MARK: - Public properties

	// MARK: - Dependencies
	var handlerTitleDelegate: IDevicesCollectionCellHandler?

	// MARK: - Private properties
	private lazy var collectionDevices = createCollectionView()
	private var modelForDisplay: [MainRepairDevicesModel.ViewModel.Device] = []
	private lazy var indicatorView = IndicatorView()

	// MARK: - Initializator
	convenience init(handlerTitleDelegate: IDevicesCollectionCellHandler?) {
		self.init(frame: CGRect.zero)
		self.handlerTitleDelegate = handlerTitleDelegate
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		addUIView()
		setupConfiguration()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func reloadModel(model: [MainRepairDevicesModel.ViewModel.Device]) {
		self.modelForDisplay = model
		collectionDevices.reloadData()
	}
}

// MARK: - Add UIView.
private extension DevicesCollectionView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			collectionDevices
			// indicatorView
		]
		views.forEach(addSubview)
	}
}

// MARK: - UI configuration.
private extension DevicesCollectionView {
	/// Настройка UI элементов
	func setupConfiguration() {
		collectionDevices.backgroundColor = Theme.backgroundColor
		collectionDevices.showsHorizontalScrollIndicator = false
		collectionDevices.register(CellForDevices.self, forCellWithReuseIdentifier: CellForDevices.reuseIdentifier)
		collectionDevices.delegate = self
		collectionDevices.dataSource = self

		// indicatorView.backgroundColor = UIColor.clear
		// indicatorView.translatesAutoresizingMaskIntoConstraints = false
	}
}

// MARK: - Add constraint.
private extension DevicesCollectionView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			collectionDevices.topAnchor.constraint(equalTo: self.topAnchor),
			collectionDevices.leftAnchor.constraint(equalTo: self.leftAnchor),
			collectionDevices.rightAnchor.constraint(equalTo: self.rightAnchor),
			collectionDevices.bottomAnchor.constraint(equalTo: self.bottomAnchor)

			// indicatorView.centerXAnchor.constraint(equalTo: collectionDevices.centerXAnchor),
			// indicatorView.bottomAnchor.constraint(equalTo: collectionDevices.bottomAnchor, constant: 15),
			// indicatorView.widthAnchor.constraint(equalToConstant: 100),
			// indicatorView.heightAnchor.constraint(equalToConstant: 10)
		])
	}
}

// MARK: - CollectionView Layout.
extension DevicesCollectionView: UICollectionViewDelegateFlowLayout {
	/// Настройка размеров ячейки.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: 210, height: 130)
	}
}

// MARK: - CollectionView Source and Delegate.
extension DevicesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return modelForDisplay.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let deviceTitle = modelForDisplay[indexPath.row]
		if let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: CellForDevices.reuseIdentifier, for: indexPath
		) as? CellForDevices {
			if let image = UIImage(named: deviceTitle.imageName) {
				cell.render(image: image)
			}
			return cell
		}
		return UICollectionViewCell()
	}

	// Возвращаем название текущей ячейки, и передаем в родительское View.
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let currentDevice = modelForDisplay[indexPath.item]
		handlerTitleDelegate?.returnTitle(title: currentDevice.title, deviceID: currentDevice.id)
	}
}

// MARK: - UI Fabric.
private extension DevicesCollectionView {
	func createCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		return collectionView
	}
}
