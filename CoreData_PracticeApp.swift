//
//  CoreData_PracticeApp.swift
//  CoreData Practice
//
//  Created by Promal on 23/8/21.
//

import SwiftUI

@main
struct CoreData_PracticeApp: App {
    
    let persistanceController = PersistanceController.shared
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistanceController.container.viewContext)
        }.onChange(of: scenePhase){(newScenePhase) in
            switch newScenePhase{
            
            case .background:
                persistanceController.save()
            case .inactive:
                print("App is inaction")
            case .active:
                print("App is active")
            @unknown default:
                print("No idea what is happening")
            }
        }
    }
}
