//
//  IndicatorView.swift
//  Apple №1
//
//  Created by Steven Kirke on 25.02.2024.
//

import UIKit

final class IndicatorView: UIView {

	// MARK: - Public properties

	// MARK: - Dependencies

	// MARK: - Private properties
	private lazy var backgroundView = createView()
	private lazy var vStack = createVStack(addCircle())
	private lazy var circleIndicator = createView()
	private var modelForDisplay: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
	private var currentIndexPath: Int = 0

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

	func reload(frame: CGRect) {
		print("frame \(frame)")
	}

	func addCircle() -> [UIView] {
		var circleView: [UIView] = []
		for _ in 0..<2 {
			circleView.append(circleIndicator)
		}
		return circleView
	}
}

// MARK: - Add UIView.
private extension IndicatorView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			backgroundView,
			vStack
		]
		views.forEach(addSubview)
	}
}

// MARK: - UI configuration.
private extension IndicatorView {
	/// Настройка UI элементов
	func setupConfiguration() {
		vStack.layer.borderColor = UIColor.red.cgColor
		vStack.layer.borderWidth = 1

		circleIndicator.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
		circleIndicator.backgroundColor = UIColor.green

	}
}

// MARK: - Add constraint.
private extension IndicatorView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			vStack.topAnchor.constraint(equalTo: self.topAnchor),
			vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			vStack.leftAnchor.constraint(equalTo: self.leftAnchor),
			vStack.rightAnchor.constraint(equalTo: self.rightAnchor)
		])
	}
}

// MARK: - UI Fabric.
private extension IndicatorView {
	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createVStack(_ view: [UIView]) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: view)
		stack.axis = .horizontal
		stack.distribution = .fill
		// stack.alignment = .center
		stack.translatesAutoresizingMaskIntoConstraints = false

		return stack
	}
}
