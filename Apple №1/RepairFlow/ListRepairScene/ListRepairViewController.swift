//
//  ListRepairViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 25.02.2024.
//

import UIKit

protocol IListRepairViewLogic: AnyObject {
	func renderTitle(nameDevice: String)
	func renderRepairList(viewModel: [ListRepairModel.ViewModel.Repair])
}

final class ListRepairViewController: UIViewController {

	// MARK: - Dependencies
	var iterator: IListRepairIterator?

	// MARK: - Private properties
	private lazy var labelHeader = createHeader()
	private lazy var labelStep = createLabel()
	private lazy var textFieldSearch = createTextField()
	private lazy var buttonClear = createButton()
	private lazy var collectionRepair = createCollectionView()
	// Модели для отображения.
	private var titleDevice: String = ""
	private var modelForDisplay: [ListRepairModel.ViewModel.Repair] = []
	private var modelForDisplaySearching: [ListRepairModel.ViewModel.Repair] = []

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
		iterator?.fitchNameDevice()
		iterator?.fitchRepairList()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
		labelHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
	}
}

// MARK: - Add UIView.
private extension ListRepairViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			labelStep,
			textFieldSearch,
			collectionRepair
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - UI configuration.
private extension ListRepairViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		configuratorNavigationBar()
		configureLabel()
		configuratorTextFieldSearch()
		configuratorCollectionView()
	}
	// Настройка поля текстового ввода.
	func configuratorTextFieldSearch() {
		textFieldSearch.delegate = self
		textFieldSearch.layer.borderWidth = 1
		textFieldSearch.layer.zPosition = labelHeader.layer.zPosition - 1
		textFieldSearch.rightView = buttonClear
		textFieldSearch.rightViewMode = .always
	}
	// Настройка CollectionView.
	func configuratorCollectionView() {
		collectionRepair.backgroundColor = Theme.backgroundColor
		collectionRepair.showsVerticalScrollIndicator = false
		collectionRepair.register(
			CellForRepair.self, forCellWithReuseIdentifier: CellForRepair.reuseIdentifier
		)
		collectionRepair.delegate = self
		collectionRepair.dataSource = self
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
		labelStep.text = "Выберите неисправность \n 2 шаг из 3"
		labelStep.font = UIFont.boldSystemFont(ofSize: 14.0)
		labelStep.textColor = Theme.mainColor.withAlphaComponent(0.6)
		labelStep.numberOfLines = 2
		labelStep.backgroundColor = Theme.backgroundColor
		labelStep.translatesAutoresizingMaskIntoConstraints = false
	}
}

// MARK: - Add constraint.
private extension ListRepairViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		let saveAreaTop = view.safeAreaInsets.top
		NSLayoutConstraint.activate([
			labelStep.topAnchor.constraint(equalTo: view.topAnchor, constant: saveAreaTop),
			labelStep.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			labelStep.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			labelStep.heightAnchor.constraint(equalToConstant: 40),

			textFieldSearch.topAnchor.constraint(equalTo: labelStep.topAnchor),
			textFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			textFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			textFieldSearch.heightAnchor.constraint(equalToConstant: 40),

			collectionRepair.topAnchor.constraint(equalTo: textFieldSearch.bottomAnchor, constant: 10),
			collectionRepair.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
			collectionRepair.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
			collectionRepair.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

// MARK: - CollectionView Layout.
extension ListRepairViewController: UICollectionViewDelegateFlowLayout {
	// Настройка размеров ячейки.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: collectionView.frame.width, height: 150)
	}
}

// MARK: - CollectionView Source and Delegate.
extension ListRepairViewController: UICollectionViewDataSource, UIColorPickerViewControllerDelegate {
	// Действие по клику на ячейку.
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if !modelForDisplaySearching.isEmpty {
			let currentRepair = modelForDisplaySearching[indexPath.row]
			iterator?.nextScene(deviceTitle: titleDevice, modelRepair: currentRepair)
		} else {
			let currentRepair = modelForDisplay[indexPath.row]
			iterator?.nextScene(deviceTitle: titleDevice, modelRepair: currentRepair)
		}
	}

	// Количество ячеек.
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		var count = modelForDisplay.count
		if !modelForDisplaySearching.isEmpty {
			count = modelForDisplaySearching.count
		}
		return count
	}
	// Регистрация ячейки и заполнение данными.
	func collectionView(
		_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		var model = modelForDisplay[indexPath.row]
		if !modelForDisplaySearching.isEmpty {
			model = modelForDisplaySearching[indexPath.row]
		}

		let cell = collectionRepair.dequeueReusableCell(
			withReuseIdentifier: CellForRepair.reuseIdentifier, for: indexPath
		)
		if let currentCell = cell as? CellForRepair {
			currentCell.reloadData(title: model.title, description: model.description)
			return currentCell
		}
		return UICollectionViewCell()
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y < -100 {
			self.startAnimation()
		} else if scrollView.contentOffset.y > 80 {
			self.stopAnimation()
			self.modelForDisplaySearching = []
			self.collectionRepair.reloadData()
		}
	}
}

extension ListRepairViewController: UITextFieldDelegate {
	// Обработка поля поиска.
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		if case let fieldSearch = textField, let currentText = fieldSearch.text {
			liveSearchInModel(currentText)
			return true
		}
		return false
	}

	private func liveSearchInModel(_ text: String) {
		self.modelForDisplaySearching = modelForDisplay.filter {
			if $0.title.lowercased().contains("\(text)".lowercased()) {
				return true
			}
			return false
		}
		if text.isEmpty {
			self.modelForDisplaySearching = []
		}
		collectionRepair.reloadData()
	}
}

// MARK: - UI Fabric.
private extension ListRepairViewController {
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

	func createCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}

	func createTextField() -> UITextField {
		let textField = UITextField()
		textField.backgroundColor = Theme.accentColor
		textField.keyboardType = .default
		textField.textColor = Theme.mainColor
		textField.tintColor = Theme.mainColor
		textField.layer.cornerRadius = Styles.Radius.radiusTextField
		textField.layer.borderColor = Theme.mainColor.cgColor
		textField.layer.borderWidth = Styles.Border.one
		textField.setLeftPadding(Styles.Padding.average)
		textField.setRightPadding(Styles.Padding.average)
		textField.attributedPlaceholder = NSAttributedString(
			string: "Поиск...",
			attributes: [NSAttributedString.Key.foregroundColor: Theme.mainColor]
		)
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}

	func createButton() -> UIButton {
		let button = UIButton()
		let configurator = UIImage.SymbolConfiguration(textStyle: .title2)
		let image = UIImage(systemName: "multiply.circle", withConfiguration: configurator)
		button.setImage(image, for: .normal)
		button.imageEdgeInsets = UIEdgeInsets(top: .zero, left: -16, bottom: .zero, right: .zero)
		button.addTarget(self, action: #selector(closeTextField), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
}

// MARK: - Animation.
private extension ListRepairViewController {
	func startAnimation() {
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: [.curveLinear],
			animations: {
				self.textFieldSearch.transform = CGAffineTransform(translationX: 0, y: 45)
				self.collectionRepair.transform = CGAffineTransform(translationX: 0, y: 45)
			})
	}

	func stopAnimation() {
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: [.curveLinear],
			animations: {
				self.textFieldSearch.transform = CGAffineTransform(translationX: 0, y: 0)
				self.collectionRepair.transform = CGAffineTransform(translationX: 0, y: 0)
			})
	}
}

// MARK: - UI Action.
private extension ListRepairViewController {
	@objc func closeTextField() {
		textFieldSearch.text = ""
		modelForDisplaySearching = []
		collectionRepair.reloadData()
	}
}

// MARK: - Logic
extension ListRepairViewController: IListRepairViewLogic {
	func renderRepairList(viewModel: [ListRepairModel.ViewModel.Repair]) {
		self.modelForDisplay = viewModel
		collectionRepair.reloadData()
	}

	func renderTitle(nameDevice: String) {
		self.titleDevice = nameDevice
		labelHeader.text =  "Ремонт \n\(self.titleDevice)"
	}
}
