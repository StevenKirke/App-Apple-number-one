//
//  AppDelegate.swift
//  Apple №1
//
//  Created by Steven Kirke on 29.12.2023.
//

import UIKit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		YMKMapKit.setApiKey("b4de564f-60d7-487c-967f-e05b52623987")
		YMKMapKit.setLocale("ru_RU")
		YMKMapKit.sharedInstance()
		return true
	}

	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
}
