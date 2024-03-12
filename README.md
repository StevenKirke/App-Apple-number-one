#  СЕРВИСНЫЙ ЦЕНТР APPLE №1

## Description
#### Данное приложение предназначено для взаимодействия с сервисным центром APPLE №1. 
#### Включает в себя сцены:
##### * "Ремонт",
##### * "Статус".
##### * "Профиль пользователя", 
##### * "Контакты",
##### * "Акции"

## Getting started
#### Для дальнейшей работы, необходимо скачать архив или клонировать проект с ресурса GitHub.
#### Разархивировать и приступить к работе.

## Usage
####

## Architecture
#### В данном проекте используется архитектура Clean Architecture + Coordinator.

## Structure
### Current structure 
### (Отображение структуры в GitHub не соответствует структуре в проекте, ниже приведена файловая структура проекта)

``` bash
└── Apple №1
    ├── README.md
    └── Apple №1
        ├── Emuns
        │   ├── RegexPatterns.swift
        │   ├── iPhoneSeries.swift
        │   └── DeviceLines.swift
        ├── Entity
        │   └── TreeNodeCatalog
        │       ├── TreeNode.swift
        │       ├── TreeCategory.swift
        │       └── TreeOffer.swift
        ├── Mocks
        │   ├── catalogList.xml
        │   ├── ModelAdressWorkshops.swift
        │   └── ModelsAndRepair.json
        ├── Services
        │   ├── ConvertService.swift
        │   ├── CodeGenerateService.swift
        │   ├── PhoneMaskService.swift
        │   └── AssemblerURLService.swift
        ├── Managers
        │   ├── CNContactManager.swift
        │   ├── TimerManager.swift
        │   ├── DecodeJsonManager.swift
        │   ├── NetworkManager.swift
        │   ├── LoadFileManager.swift
        │   └── LocationManager.swift
        ├── Converters
        │   ├── ConvertorDevicesDTO.swift
        │   ├── ConvertToSeriesAndModelDTO.swift
        │   └── ConvertorRepairModelDTO.swift
        ├── Styles
        │   └── GlobalStyleSettings.swift
        ├── Extensions
        │   ├── ExtensionUIViewController.swift
        │   ├── ExtensionUIApplication.swift
        │   └── ExtensionUIColor.swift
        ├── Assets
        │   └── Colors
        │       ├── CustomColors.swift
        │       └── StyleColors.swift
        ├── CustomUI
        │   └── FabricUI.swift
        ├── Coordinators
        │   │── Common
        │   │   └── ICoordinator.swift
        │   ├── AppCoordinator.swift
        │   ├── LoginCoordinator.swift
        │   ├── MainCoordinator.swift
        │   ├── RepairCoordinator.swift
        │   ├── StatusCoordinator.swift
        │   ├── ProfileCoordinator.swift
        │   ├── ContactCoordinator.swift
        │   └── StockCoordinator.swift
        ├── Flows
        │   ├── IConfigurator.swift
        │   ├── LoginFlow
        │   │   └── LoginScene
        │   │       ├── LoginAssembler.swift
        │   │       ├── LoginViewController.swift
        │   │       ├── LoginIterator.swift
        │   │       ├── LoginPresenter.swift
        │   │       ├── LoginViewModel.swift
        │   │       └── LoginWorker.swift
        │   ├── MainFlow
        │   │   ├── TabBarController.swift
        │   │   └── TabBarPage.swift
        │   ├── RepairFlow
        │   │   ├── MainRepairScene
        │   │   │   ├── AssemblerMainRepair.swift
        │   │   │   ├── MainRepairViewController.swift
        │   │   │   ├── MainRepairIterator.swift
        │   │   │   ├── MainRepairPresenter.swift
        │   │   │	├── Models
        │   │   │   │	├── MainRepairDevicesModel.swift
        │   │   │   │	└── MainRepairSeriesModel.swift
        │   │   │	├── Worker
        │   │   │   │ 	├── MainRepairWorker.swift
        │   │   │  	│ 	└── CatalogSeriesDTO.swift
        │   │   │	└── CollectionViews
        │   │   │    	├── DevicesCollectionView
        │   │   │    	│	├── DevicesCollectionView.swift
        │   │   │    	│	├── CustomCellForDevice.swift
        │   │   │    	│	└── IndicatorView.swift
        │   │   │    	└── SeriesCollectionView
        │   │   │    	 	├── SeriesCollectionView.swift
        │   │   │    	 	├── HeaderForSeriesCollection.swift
        │   │   │    	 	├── CellForSeriesView.swift
        │   │   │    	 	└── EmptyCellForSeriesView.swift
        │   │   │── ListRepairScene
        │   │   │   ├── ListRepairAssembler.swift
        │   │   │   ├── ListRepairViewController.swift
        │   │   │   ├── ListRepairIterator.swift
        │   │   │   ├── ListRepairPresenter.swift
        │   │   │   ├── ListRepairViewModel.swift
        │   │   │	├── AdditionalView
        │   │   │ 	│ 	└── CustomCellForRepair.swift
        │   │   │	└── Worker
        │   │   │  	  	├── ListRepairWorker.swift
        │   │   │ 	 	└── ListRepairDTO.swift
        │   │   └── OrderScene
        │   │       ├── OrderRepairAssembler.swift
        │   │       ├── OrderRepairViewController.swift
        │   │       ├── OrderRepairIterator.swift
        │   │       ├── OrderRepairPresenter.swift
        │   │       ├── OrderRepairModel.swift
        │   │       ├── OrderRepairWorker.swift
        │   │    	└── AdditionalView
        │   │     	 	└── BonusView.swift
        │   ├── StatusFlow
        │   │   └── MainStatusScene
        │   │       ├── AssemblerMainStatus.swift
        │   │       └── MainStatusViewController.swift
        │   ├── ProfileFlow
        │   │   └── MainProfileScene
        │   │       ├── AssemblerMainProfile.swift
        │   │       └── MainProfileViewController.swift
        │   ├── ContactFlow
        │   │   └── MainContactScene
        │   │       ├── AssemblerMainContact.swift
        │   │       ├── MainContactViewController.swift
        │   │       ├── MainContactIterator.swift
        │   │       ├── MainContactPresenter.swift
        │   │       ├── MainContactModel.swift
        │   │       ├── MainContactWorker.swift
        │   │    	└── AdditionalView
        │   │     	 	└── CellForContact.swift
        │   ├── StockFlow
        │   │   └── MainStockScene
        │   │       ├── AssemblerMainStock.swift
        │   │       └── MainStockViewController.swift
        │   ├── CommonScenes
        │   │   ├── ContactListScene
        │   │   │   ├── ContactListAssembler.swift
        │   │   │   ├── ContactListViewController.swift
        │   │   │   ├── ContactListIterator.swift
        │   │   │   ├── ContactListPresenter.swift
        │   │   │   └── ContactListModel.swift
        │   │   └── CustomUIAlertScene
        │   │       ├── CustomUIAlertController.swift
        │   │       └── CustomUIAlertModel.swift
        ├── Application
        │   ├── AppDelegate.swift
        │   └── SceneDelegate.swift
        └── Resources
            ├── Fonts
            │   │── SFLight
            │   │── SFBoldItalic
            │   │── SFRegular
            │   └── SFMedium
            ├── swiftlint.yml
            ├── LaunchScreen.storyboard
            ├── Assets.xcassets
            └── Info.plist
```

## Running the tests

## Dependencies
#### Зависимостей нет.

## Workflow
#### App version:
#### iOS version:

## Design
#### Дизайн для приложения выполнен в Figma.
####	Новая версия. 
#### [Figma](https://www.figma.com/file/UilX9s9xLs6QtDMtxCO3D6/Untitled?type=design&node-id=0%3A1&mode=design&t=E2mVT3sOlIv3BkhG-1)

#### Старая версия. 
#### [Figma](https://www.figma.com/file/qqShRCs7Vqu5gRhpv9Hzu8/MainView?type=design&node-id=0%3A1&mode=design&t=ntE4GJkYc6oA8HaC-1)

## Task boards
#### 

## API
#### В приложении используются API, такте как:
##### * [RemOnline](https://remonline.app/docs/api/?_gl=1*1i4v9l*_gcl_aw*R0NMLjE2MTYwNjI3NTAuQ2p3S0NBanc5TXVDQmhCVUVpd0FiRFotN3VIbXFKVDJ6a3lwUm85STFJT1oxckFZVUJzaG10Z1B6ZktZa0NDWXNaTzBqNzIyT2FWXzFCb0M5cTRRQXZEX0J3RQ..&_ga=2.33418941.2084054265.1616062750-110049959.1616062750&_gac=1.61555038.1616062750.CjwKCAjw9MuCBhBUEiwAbDZ-7uHmqJT2zkypRo9I1IOZ1rAYUBshmtgPzfKYkCCYsZO0j722OaV_1BoC9q4QAvD_BwE) 

####  * Новые API, будут добавляться по мере развития приложения.
