//
//  ContactListViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 02.01.2024.
//

import UIKit

/// Протокол, отображение получаемых из вне данных.
protocol IContactListViewLogic: AnyObject {
	/// Отображение получаемых из вне данных.
	/// - Parameters:
	///		- contactList: Модель контактов, для отображения во View.
	func render(contactList: [ContactListDisplay])
}

/// Протокол обработка действий пользователя.
protocol IContactListViewHandler: AnyObject {
	/// Запрос списка контактов.
	func getContact()

	/// Обработчик закрытия окна контактов с сохранением выбранного контакта.
	/// - Parameters:
	/// 	- number: Структура номера телефона пользователя:
	///			- Номера телефона пользователя, числовые символы.
	///			- Номер телефона с маской.
	func handleContact(number: PhoneNumberModel)
}

final class ContactListViewController: UITableViewController {

	// MARK: - Dependencies
	var iterator: IContactListIterator?

	// MARK: - Private properties
	private let customUI = FabricUI()
	private lazy var backButton = customUI.forContactsList()
	private var modelForDisplay: [ContactListDisplay] = []

	// MARK: - Initializator
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfiguration()
		getContact()
	}
}

// MARK: - Initialisation configuration
private extension ContactListViewController {
	/// Настройка UI элементов.
	func setupConfiguration() {
		// Название текущего View.
		navigationItem.title = "Контакты"
		let textAttributes = [NSAttributedString.Key.foregroundColor: Theme.mainColor]
		navigationController?.navigationBar.titleTextAttributes = textAttributes
		navigationController?.navigationBar.tintColor = Theme.mainColor

		tableView.separatorColor = Theme.accentColor
		tableView.separatorStyle = .singleLine
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.backgroundColor = Theme.backgroundColor
		tableView.dataSource = self
		tableView.delegate = self
	}
}

// MARK: - Setup TableView.
extension ContactListViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		modelForDisplay.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.modelForDisplay[section].phones.count
	}

	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if let view = view as? UITableViewHeaderFooterView {
			view.textLabel?.textColor = Theme.mainColor
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		modelForDisplay[section].name
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let phone = modelForDisplay[indexPath.section].phones[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = phone.maskPhone
		cell.backgroundColor = Theme.backgroundColor
		cell.textLabel?.textColor = Theme.mainColor
		cell.textLabel?.textAlignment = .right
		cell.selectionStyle = .none
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let currentNumber = modelForDisplay[indexPath.section].phones[indexPath.row]
		handleContact(number: currentNumber)
	}
}

// MARK: - Render
extension ContactListViewController: IContactListViewLogic {
	func render(contactList: [ContactListDisplay]) {
		DispatchQueue.main.async {
			self.modelForDisplay = contactList
			self.tableView.reloadData()
		}
	}
}

// MARK: - Action UI
extension ContactListViewController: IContactListViewHandler {
	func getContact() {
		Task.init {
			await iterator?.fetchContact()
		}
	}

	func handleContact(number: PhoneNumberModel) {
		iterator?.handleContact(number: number)
	}
}
