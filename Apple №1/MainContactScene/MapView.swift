//
//  MapView.swift
//  Apple №1
//
//  Created by Steven Kirke on 12.03.2024.
//

import UIKit
import YandexMapsMobile

final class MapView: UIView {

	// MARK: - Private properties
	private lazy var mapView: YMKMapView = YMKMapView()
	private lazy var imageMark = createImage()

	override init(frame: CGRect) {
		super.init(frame: frame)
		addUIView()
		setupConfiguration()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func reload(coordinate: MainContactModel.Request.Coordinates) {
		print("coordinate")
		self.addPlace(coordinate: coordinate)
		addPlaceMark(coordinate: coordinate.flag)
	}
 }

// MARK: - Add UIView.
private extension MapView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			mapView
		]
		views.forEach(addSubview)
	}
}

// MARK: - UI configuration.
private extension MapView {
	/// Настройка UI элементов
	func setupConfiguration() { }
}

// MARK: - Add constraint.
private extension MapView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: self.topAnchor),
			mapView.leftAnchor.constraint(equalTo: self.leftAnchor),
			mapView.rightAnchor.constraint(equalTo: self.rightAnchor),
			mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
}

// MARK: - UI Fabric.
private extension MapView {
	func createImage() -> UIImage {
		let image = UIImage(named: "Images/Logos/Placemark")
		return image ?? UIImage()
	}
}

// MARK: - Render logic.
private extension MapView {
	func addPlace(coordinate: MainContactModel.Request.Coordinates) {
		let point = YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
		DispatchQueue.main.async {
			self.mapView.mapWindow.map.move(
				with: YMKCameraPosition(
					target: point,
					zoom: Float(coordinate.zoom),
					azimuth: 0,
					tilt: 0
				),
				animation: YMKAnimation(type: .smooth, duration: 1),
				cameraCallback: nil
			)
		}
	}

	func addPlaceMark(coordinate: MainContactModel.Request.FlagCoordinates) {
		Task.init {
			let point = YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
			let viewPlacemark = self.mapView.mapWindow.map.mapObjects.addPlacemark(with: point)
			viewPlacemark.setIconWith(
				self.imageMark,
				style: YMKIconStyle(
					anchor: CGPoint(x: 0.5, y: 1) as NSValue,
					rotationType: YMKRotationType.rotate.rawValue as NSNumber,
					zIndex: 0,
					flat: true,
					visible: true,
					scale: 0.5,
					tappableArea: nil
				))
		}
	}
}
