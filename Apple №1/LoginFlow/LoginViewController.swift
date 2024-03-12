//
//  LoginViewController.swift
//  Apple №1
//
//  Created by Steven Kirke on 01.01.2024.
//

import UIKit

// MARK: - Add render LoginViewModel from SignInPresenter
protocol ILoginInViewLogic: AnyObject {
	/// Отображение данный из ``ContactListPresenter``
	func renderNumber(model: PhoneModelForLoginView)
	func renderCode(model: CodeModelForLoginView)
	func renderError()
}

final class LoginViewController: UIViewController {

	// MARK: - Dependencies
	var iterator: ILoginInIterator?
	var delegate: IUpdateTimer?
	private var phoneMaskService: IPhoneMaskService?

	// MARK: - Private properties
	private let customUI = FabricUI()
	private let customTimer = TimerManager(delegate: nil)
	private lazy var labelSignIn = customUI.createLabel()
	private lazy var labelVersion = customUI.createLabel()
	private lazy var labelEmptyField = customUI.createLabel()
	private lazy var labelTitleTimer = customUI.createLabel()
	private lazy var labelTimer = customUI.createLabel()
	private lazy var imageLogoMask = customUI.createImage("Images/Logos/LogoMask")
	private lazy var imageLogo = customUI.createImage("Images/Logos/LogoNoGlow")
	private lazy var imageLogoAnimateFirst = customUI.createImage("Images/Logos/LogoNoGlow")
	private lazy var imageLogoAnimateSecond = customUI.createImage("Images/Logos/LogoNoGlow")
	private lazy var fieldPhone = customUI.createTextField("Номер")
	private lazy var fieldCode = customUI.createTextField("Проверочный код")
	private lazy var buttonContact = customUI.createButtonWithImage("person", Styles.Fonts.bigger)
	private lazy var buttonExit = customUI.createButton("Получить код")
	private var modelForDisplayContact = PhoneModelForLoginView(phoneNumeric: "", maskPhone: "")
	private var modelForDisplayCode = CodeModelForLoginView(code: "", checkCode: "")
	private var isActionScene: Bool = false

	private enum TitleForFieldEmpty: String {
		case emptyFieldPhone = "Поле ввода номера пустое."
		case emptyFieldCode = "Введен не корректный проверочный код."
	}

	// MARK: - Initializator
	init(phoneMaskService: IPhoneMaskService) {
		super.init(nibName: nil, bundle: nil)
		self.phoneMaskService = phoneMaskService
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		closeKeyboard()
		setupConfiguration()
		addUI()
		fetchVersionAndBuild()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		setupLayout()
	}
}

// MARK: - Add UI in View
private extension LoginViewController {
	/// Добавление элементов в 'SignInViewController'
	func addUI() {
		let views: [UIView] = [
			imageLogoMask, imageLogo, imageLogoAnimateFirst, imageLogoAnimateSecond, labelSignIn, labelTitleTimer,
			labelTimer, labelVersion, labelEmptyField, fieldPhone, fieldCode, buttonExit
		]
		views.forEach(view.addSubview)
	}
}

// MARK: - Initialisation configuration
private extension LoginViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		view.backgroundColor = Theme.backgroundColor
		imageLogoMask.image?.withRenderingMode(.alwaysTemplate)
		// MARK: поменять цвет!
		imageLogoMask.tintColor = Theme.backgroundColor
		imageLogoMask.layer.zPosition = -Styles.ZPosition.ten

		imageLogoAnimateFirst.layer.zPosition = -Styles.ZPosition.eleven
		imageLogoAnimateFirst.alpha = Styles.Alpha.threeTenths

		imageLogoAnimateSecond.layer.zPosition = -Styles.ZPosition.twelve
		imageLogoAnimateSecond.alpha = Styles.Alpha.threeTenths

		// Настройка UILabel 'Регистрация'
		labelSignIn.text = "Регистрация"
		labelSignIn.font = UIFont.systemFont(ofSize: Styles.Fonts.huge, weight: .regular)

		// Настройка 'UILabel' ошибка пустой поле 'fieldPhone'
		labelEmptyField.numberOfLines = 2
		labelEmptyField.isHidden = true

		// Настройка 'UILabel', title для таймера.
		labelTitleTimer.text = "Проверочный код:"
		labelTitleTimer.font = UIFont.systemFont(ofSize: Styles.Fonts.small, weight: .regular)
		labelTitleTimer.textAlignment = .left
		labelTitleTimer.isHidden = true

		// Настройка 'UILabel', отображения таймера, валидации кода.
		labelTimer.text = "01:00"
		labelTimer.font = UIFont.systemFont(ofSize: Styles.Fonts.small, weight: .regular)
		labelTimer.textAlignment = .left
		labelTimer.isHidden = true

		// Настройка UILabel 'Версия приложения'
		labelVersion.font = UIFont.systemFont(ofSize: Styles.Fonts.small, weight: .light)

		// Настройка UITextField 'Номер телефона'
		fieldPhone.rightViewMode = .always
		fieldPhone.rightView = buttonContact
		fieldPhone.delegate = self

		// Настройка UITextField 'Проверочный код'
		fieldCode.isSecureTextEntry = true
		fieldCode.delegate = self

		// Добавление 'Action' на кнопку 'Открыть телефонную книгу'
		buttonContact.addTarget(self, action: #selector(openContactList), for: .touchUpInside)
		// Подключение Action для валидации номера телефона и перехода на следующий экран.
		buttonExit.addTarget(self, action: #selector(fetchCode), for: .touchUpInside)
	}
}

// MARK: - Action UI
private extension LoginViewController {
	/// 'Открыть телефонную книгу'
	@objc private func openContactList() {
		modelForDisplayContact.maskPhone = ""
		modelForDisplayContact.phoneNumeric = ""
		stopTimer()
		iterator?.showContactList()
	}

	/// Валидация телефонного номера пользователя и переход на следующий экран
	@objc private func fetchCode() {
		if modelForDisplayContact.phoneNumeric.isEmpty {
			checkIsEmptyField()
		} else {
			fieldCode.becomeFirstResponder()
			isActionScene = true
			runImageAnimation()
			self.customTimer.startTimer()
			customTimer.delegate = self
			self.iterator?.fetchCode()
		}
	}

	/// Прячем клавиатуру
	private func closeKeyboard() {
		self.hideKeyboard()
	}
}

// MARK: Add TimerManager.
extension LoginViewController: IUpdateTimer {
	func updateLabel(returnTime: String) {
		labelTimer.text = returnTime
	}

	func stopTimer() {
		isActionScene = false
		runImageAnimation()
	}
}

// Обработка визуализации работы таймера, блокировка кнопки, отображение UILabel.
private extension LoginViewController {
	func runImageAnimation() {
		DispatchQueue.main.async {
			if self.isActionScene {
				self.animateViewElement()
			} else {
				self.noAnimateViewElement()
			}
		}
	}

	/// Отображение анимации, показ UILabel времени проверочного кода, блокировка кнопки.
	func animateViewElement() {
		buttonExit.isEnabled = false
		labelTitleTimer.isHidden = false
		labelTimer.isHidden = false
		startAnimation(viewForAnimation: imageLogoAnimateFirst, delay: .zero)
		startAnimation(viewForAnimation: imageLogoAnimateSecond, delay: Styles.Time.one)
	}

	/// Отключение анимации, скрытие UILabel проверочного кода, разблокировка кнопки.
	func noAnimateViewElement() {
		buttonExit.backgroundColor = .addColor(.colorE94135)
		buttonExit.isEnabled = true
		labelTitleTimer.isHidden = true
		labelTimer.isHidden = true
		stopAnimation()
	}

	func startAnimation(viewForAnimation: UIImageView, delay: Double) {
		let scaleMin = Styles.Scale.one
		let scaleMax = Styles.Scale.eighteen
		UIView.animate(
			withDuration: Styles.Time.two,
			delay: delay,
			options: [.curveEaseOut, .repeat],
			animations: {
				viewForAnimation.alpha = .zero
				viewForAnimation.transform = CGAffineTransform(scaleX: scaleMax, y: scaleMax)
			},
			completion: { _ in
				viewForAnimation.alpha = Styles.Alpha.fourTenths
				viewForAnimation.transform = CGAffineTransform(scaleX: scaleMin, y: scaleMin)
			})
	}

	func stopAnimation() {
		imageLogoAnimateFirst.layer.removeAllAnimations()
		imageLogoAnimateSecond.layer.removeAllAnimations()
	}
}

// MARK: - Обработка UITextField "Номер телефона"
extension LoginViewController: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		switch textField {
		case fieldPhone:
			handlerFieldPhone(replacementString: string)
		case fieldCode:
			handlerFieldCode(replacementString: string)
		default:
			return false
		}
		return false
	}

	private func handlerFieldPhone(replacementString: String) {
		if replacementString == "" {
			if !modelForDisplayContact.phoneNumeric.isEmpty {
				modelForDisplayContact.phoneNumeric.removeLast()
			}
			if !modelForDisplayContact.maskPhone.isEmpty {
				modelForDisplayContact.maskPhone.removeLast()
			}
		}
		if let phoneService = phoneMaskService {
			modelForDisplayContact.phoneNumeric += replacementString
			let convert = phoneService.handlingPhone(phoneNumber: modelForDisplayContact.phoneNumeric)
			modelForDisplayContact.phoneNumeric = convert.0
			modelForDisplayContact.maskPhone = convert.1
			fieldPhone.text = modelForDisplayContact.maskPhone
		}
	}

	private func handlerFieldCode(replacementString: String) {
		if replacementString == "" {
			if !modelForDisplayCode.code.isEmpty {
				modelForDisplayCode.code.removeAll()
			}
		}
		modelForDisplayCode.code += replacementString
		fieldCode.text = modelForDisplayCode.code
		if modelForDisplayCode.code == modelForDisplayCode.checkCode {
			stopTimer()
			iterator?.showMainScene()
		}
	}
}

// MARK: - Показ предупреждвющей надписи при пустом поле ввода, отображение таймера валидации.
extension LoginViewController {
	/// Проверка пустоты поля ввода номер телефона.
	/// В случае проверки на пустоту текстового поля отображается предупреждающая надпись,
	///	по истечении 3 секунд скрывающаяся.
	func checkIsEmptyField() {
		let title = TitleForFieldEmpty.emptyFieldPhone
		labelEmptyField.text = title.rawValue
		labelEmptyField.isHidden = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.labelEmptyField.isHidden = true
		}
	}
}

// MARK: Version application.
private extension LoginViewController {
	func fetchVersionAndBuild() {
		let versionAndBuild = UIApplication.shared.versionAndBuild()
		labelVersion.text = "Версия приложения: \(versionAndBuild)"
	}
}

// MARK: Protocol - ISignInViewLogic
extension LoginViewController: ILoginInViewLogic {
	func renderNumber(model: PhoneModelForLoginView) {
		navigationController?.navigationBar.isHidden = true
		modelForDisplayContact = model
		fieldPhone.text = modelForDisplayContact.maskPhone
	}

	func renderCode(model: CodeModelForLoginView) {
		modelForDisplayCode.code = ""
		modelForDisplayCode.checkCode = ""
		modelForDisplayCode.checkCode = model.checkCode
	}

	func renderError() {
		stopTimer()
	}
}

// MARK: - Layout setup.
private extension LoginViewController {
	func setupLayout() {
		let padding = Styles.Padding.self
		let width = view.frame.width
		NSLayoutConstraint.activate([
			imageLogoAnimateFirst.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageLogoAnimateFirst.bottomAnchor.constraint(equalTo: labelSignIn.topAnchor, constant: -padding.bigger),
			imageLogoAnimateFirst.widthAnchor.constraint(equalToConstant: width / 3),
			imageLogoAnimateFirst.heightAnchor.constraint(equalToConstant: width / 3),

			imageLogoAnimateSecond.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageLogoAnimateSecond.bottomAnchor.constraint(equalTo: labelSignIn.topAnchor, constant: -padding.bigger),
			imageLogoAnimateSecond.widthAnchor.constraint(equalToConstant: width / 3),
			imageLogoAnimateSecond.heightAnchor.constraint(equalToConstant: width / 3),

			imageLogoMask.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageLogoMask.bottomAnchor.constraint(equalTo: labelSignIn.topAnchor, constant: -padding.bigger),
			imageLogoMask.widthAnchor.constraint(equalToConstant: width / 3),
			imageLogoMask.heightAnchor.constraint(equalToConstant: width / 3),

			imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageLogo.bottomAnchor.constraint(equalTo: labelSignIn.topAnchor, constant: -padding.bigger),
			imageLogo.widthAnchor.constraint(equalToConstant: width / 3),
			imageLogo.heightAnchor.constraint(equalToConstant: width / 3),

			labelSignIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			labelSignIn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.average),
			labelSignIn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.average),
			labelSignIn.bottomAnchor.constraint(equalTo: fieldPhone.topAnchor, constant: -padding.bigger),

			labelTitleTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -Styles.Heights.twentyFive),
			labelTitleTimer.topAnchor.constraint(equalTo: labelSignIn.bottomAnchor, constant: padding.small),

			labelTimer.leadingAnchor.constraint(equalTo: labelTitleTimer.trailingAnchor, constant: Styles.Heights.teen),
			labelTimer.topAnchor.constraint(equalTo: labelSignIn.bottomAnchor, constant: padding.small),

			fieldPhone.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			fieldPhone.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			fieldPhone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.big),
			fieldPhone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.big),
			fieldPhone.heightAnchor.constraint(equalToConstant: padding.bigger),

			fieldCode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			fieldCode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.big),
			fieldCode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.big),
			fieldCode.heightAnchor.constraint(equalToConstant: padding.bigger),
			fieldCode.topAnchor.constraint(equalTo: fieldPhone.bottomAnchor, constant: padding.big),

			buttonContact.widthAnchor.constraint(equalToConstant: padding.bigLittle),
			buttonContact.heightAnchor.constraint(equalToConstant: padding.bigLittle),
			buttonExit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonExit.topAnchor.constraint(equalTo: fieldCode.bottomAnchor, constant: padding.average),
			buttonExit.heightAnchor.constraint(equalToConstant: padding.bigger),
			buttonExit.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Styles.Multiplay.fiveTenths),

			labelEmptyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			labelEmptyField.topAnchor.constraint(equalTo: labelSignIn.bottomAnchor, constant: padding.small),

			labelVersion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			labelVersion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.average),
			labelVersion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.average),
			labelVersion.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.average)
		])
	}
}
