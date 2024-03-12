//
//  EmptyCellForSeries.swift
//  Apple №1
//
//  Created by Steven Kirke on 22.02.2024.
//

import UIKit

final class EmptyCellForSeries: UICollectionViewCell {

	// MARK: - Public properties
	static let reuseIdentifier = "EmptyCellForSeries.cell"

	// MARK: - Initializator
	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
