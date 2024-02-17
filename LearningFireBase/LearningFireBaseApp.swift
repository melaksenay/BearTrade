//
//  LearningFireBaseApp.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/23/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("We have configured firebase.")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
}

@main
struct LearningFireBaseApp: App {
    //register app delgate for firebase setup.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            PerformanceView()
            RootView()
//            NavigationStack{
//                AuthenticationView()
//            }
        }
    }
}
