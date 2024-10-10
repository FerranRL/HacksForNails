//
//  HacksForNailsApp.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 17/6/24.
//

import SwiftUI
import Firebase

// MARK: Initialiting Firebase
class AppDelegateBridge: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    // MARK: Phone auth needs to initialize remote notifications
    @MainActor
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
}

@main
struct HacksForNailsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegateBridge.self) var delegate
    @StateObject var loginModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyBackground()
                .environmentObject(loginModel)
        }
    }
}
