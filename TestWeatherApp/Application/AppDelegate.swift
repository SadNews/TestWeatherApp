//
//  AppDelegate.swift
//  TestWeatherApp
//
//  Created by Андрей Ушаков on 20.08.2020.
//  Copyright © 2020 Андрей Ушаков. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = CityListViewController(nibName: "TableViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        saveContext()

        return true
    }
    
    // MARK: - Core Data stack
    func saveContext() {
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "TestWeatherApp")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        ContextSingltone.shared.context = persistentContainer.viewContext
    }
}
