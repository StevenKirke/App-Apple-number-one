//
//  SceneDelegate.swift
//  Apple №1
//
//  Created by Steven Kirke on 29.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	private var appCoordinator: AppCoordinator!

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)

		appCoordinator = AppCoordinator(window: window)
		appCoordinator.start()

		self.window = window
	}
}
