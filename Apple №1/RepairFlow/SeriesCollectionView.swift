//
//  SeriesCollectionViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 07.02.2024.
//

import UIKit

/// Обработчик нажатия на ячейку..
protocol ISeriesCellHandler: AnyObject {
	/// Возвращаем текущую модель устройства. Например "Ремонт iPhone 4"
	/// для передачи в следующее View и поиска списка неисправностей.
	func returnModel(modelDevice: MainRepairSeriesModel.ViewModel.Model)
}

final class SeriesCollectionView: UIView {

	// MARK: - Public properties

	// MARK: - Dependencies
	private var handlerHideCellDelegate: IHeaderSeriesHandler?
	var handlerSeriesCellDelegate: ISeriesCellHandler?

	// MARK: - Private properties
	private let layout = UICollectionViewFlowLayout()
	private lazy var collectionSeries = createCollectionView()
	private var modelForDisplay: [MainRepairSeriesModel.ViewModel.Series] = []
	private var isHiddenSections: [Bool] = []
	private var currentIndexPath: Int = 0

	// MARK: - Initializator
	override init(frame: CGRect) {
		super.init(frame: frame)
		addUIView()
		setupConfiguration()
		setupLayout()
	}

	convenience init(handlerSeriesCellDelegate: ISeriesCellHandler?) {
		self.init(frame: CGRect.zero)
		self.handlerSeriesCellDelegate = handlerSeriesCellDelegate
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public methods
	func reloadModel(model: [MainRepairSeriesModel.ViewModel.Series]) {
		self.isHiddenSections = []
		self.modelForDisplay = model
		for _ in modelForDisplay {
			isHiddenSections.append(true)
		}
		collectionSeries.reloadData()
	}
}

// MARK: - Add UIView.
private extension SeriesCollectionView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		addSubview(collectionSeries)
	}
}

// MARK: - UI configuration.
private extension SeriesCollectionView {
	/// Настройка UI элементов
	func setupConfiguration() {
		collectionSeries.backgroundColor = Theme.backgroundColor
		collectionSeries.showsVerticalScrollIndicator = false
		collectionSeries.register(
			CellForSeries.self,
			forCellWithReuseIdentifier: CellForSeries.reuseIdentifier
		)
		collectionSeries.register(
			EmptyCellForSeries.self,
			forCellWithReuseIdentifier: EmptyCellForSeries.reuseIdentifier
		)
		collectionSeries.register(
			HeaderForSeries.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: HeaderForSeries.identifierHeader
		)
		collectionSeries.delegate = self
		collectionSeries.dataSource = self
	}
}

// MARK: - Add constraint.
private extension SeriesCollectionView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		NSLayoutConstraint.activate([
			collectionSeries.topAnchor.constraint(equalTo: self.topAnchor),
			collectionSeries.leftAnchor.constraint(equalTo: self.leftAnchor),
			collectionSeries.rightAnchor.constraint(equalTo: self.rightAnchor),
			collectionSeries.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
}

// MARK: - CollectionView Flow Layout.
extension SeriesCollectionView: UICollectionViewDelegateFlowLayout {
	/// Настройка размеров секции.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 50)
	}

	// Настройка отступов в секции.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		if isHiddenSections[section] {
			layout.minimumLineSpacing = 0
			return UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero)
		} else {
			layout.minimumLineSpacing = 10
			return UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero)
		}
	}

	/// Настройка размеров ячейки.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		if isHiddenSections[indexPath.section] {
			return CGSize(width: collectionView.frame.width, height: 0)
		} else {
			return CGSize(width: collectionView.frame.width, height: 50)
		}
	}
}

// MARK: - CollectionView Source and Delegate.
extension SeriesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
	// Действие на ячейку.
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let currentModel = modelForDisplay[indexPath.section].models[indexPath.row]
		handlerSeriesCellDelegate?.returnModel(modelDevice: currentModel)
	}

	// Количество секции.
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		modelForDisplay.count
	}

	// Количество ячеек в секции.
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		modelForDisplay[section].models.count
	}

	// Настройке Header.
	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let headerView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: HeaderForSeries.identifierHeader,
				for: indexPath
			)
			guard let typedHeaderView = headerView as? HeaderForSeries else {
				return headerView
			}
			let headerTitle = modelForDisplay[indexPath.section].title
			typedHeaderView.render(title: headerTitle, section: indexPath.section)
			typedHeaderView.handlerButtonDelegate = self
			return typedHeaderView
		default:
			assert(false, "Unexpected element kind")
		}
	}

	// Регистрация ячейки и заполнение данными.
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var currentCell = UICollectionViewCell()
		if isHiddenSections[indexPath.section] {
			currentCell = createEmptyCell(indexPath: indexPath)
		} else {
			currentCell = createCell(indexPath: indexPath)
		}
		return currentCell
	}
	// Создание видимой ячейки.
	func createCell(indexPath: IndexPath) -> UICollectionViewCell {
		let model = modelForDisplay[indexPath.section].models[indexPath.row]
		let cell = collectionSeries.dequeueReusableCell(
			withReuseIdentifier: CellForSeries.reuseIdentifier, for: indexPath
		)
		if let currentCell = cell as? CellForSeries {
			currentCell.reloadData(title: model.title)
			return currentCell
		}
		return UICollectionViewCell()
	}
	// Создание скрытой ячейки.
	func createEmptyCell(indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionSeries.dequeueReusableCell(
			withReuseIdentifier: EmptyCellForSeries.reuseIdentifier, for: indexPath
		)
		if let currentCell = cell as? EmptyCellForSeries {
			return currentCell
		}
		return UICollectionViewCell()
	}
}

// MARK: - UI Fabric.
private extension SeriesCollectionView {
	/// Создание UICollectionView, с преобразованием изменения размера.
	func createCollectionView() -> UICollectionView {
		layout.scrollDirection = .vertical
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		return collectionView
	}
}

// MARK: - Handler.
extension SeriesCollectionView: IHeaderSeriesHandler {
	func returnIndexPath(section: Int, resultTest: (Bool) -> Void) {
		// Прячем все ячейки.
		for index in self.isHiddenSections.enumerated() where index.offset != section {
			isHiddenSections[index.offset] = true
		}
		// Меняем видимость выбранной секций - спрятать или показать.
		self.isHiddenSections[section].toggle()

		// Забираем значение для текущей секции.
		// Записываем текущую ячейку.
		self.currentIndexPath = section

		// Центрируем текущий Header.
		animateCollectionView(section: section)

		// Обновляем выбранную секцию.
		let indexSet = IndexSet(integer: section)
		self.collectionSeries.reloadSections(indexSet)

		// Возвращаем значение для анимации кнопки в Header.
		let currentSection = self.isHiddenSections[section]
		resultTest(currentSection)
	}

	// Анимация CollectionView, при нажатие на Header позиционируем по центру.
	private func animateCollectionView(section: Int) {
		let item = modelForDisplay[section].models.count - 1
		let indexPath = IndexPath(item: item, section: section)
		collectionSeries.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
	}
}
