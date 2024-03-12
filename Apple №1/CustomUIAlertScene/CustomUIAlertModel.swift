//
//  CustomUIAlertModel.swift
//  Apple №1
//
//  Created by Steven Kirke on 07.01.2024.
//

import Foundation

/// Модель обработки окна CustomUIAlertController
/**
- Parameters:
	- successBlock: Отображение положительных результатов
		каких либо действий. Например, вызов мастера.
 - errorBlock: Вывод ошибки в работе сервисов, например, ошибка сети.
 - Note: errorBlock блок принимает два параметра, название ошибки и ее описание.
*/
enum AlertMassageType {
	case successBlock
	case errorBlock(massage: String)
	// Модель Description представляет собой описание для CustomUIAlertController
	/**
	- Parameters:
		- isTypeError: Тип сообщения, необходим для отображения цветовой схкмы в сообщении.
		- imageEmoji: Изображение Emoji.
		- title: Название окна.
		- subTitle: Титры окна, описание действия.
		- errorDescription: Описание ошибки, если тип massage - errorBlock
		- errorDescription: Название для кнопки.
	 - Note: Параметры: isTypeError, imageEmoji, title, subTitle, buttonTitle
			заданы по умолчанию в инициализаторе ``AlertMassageType.Description``.
	*/
	struct Description {
		let isTypeError: Bool
		let imageEmoji: String
		let title: String
		let subTitle: String
		var errorDescription: String
		let buttonTitle: String
	}
}

extension AlertMassageType.Description {
	init(from: AlertMassageType) {
	switch from {
		case .successBlock:
			self.init(
				isTypeError: false,
				imageEmoji: "🧐",
				title: "Успешно",
				subTitle: "Ваш заказ о обработке",
				errorDescription: "",
				buttonTitle: "Хорошо"
			)
		case .errorBlock(let massage):
			self.init(
				isTypeError: true,
				imageEmoji: "😵",
				title: "Ошибка",
				subTitle: "Что-то пошло ни так...",
				errorDescription: massage,
				buttonTitle: "Закрыть"
			)
		}
	}
}
