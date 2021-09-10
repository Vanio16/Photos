//
//  Copyright © 2021 none. All rights reserved.
//

import UIKit

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }
        coordinator = .init(window: window)
        coordinator?.start()

        AppConfigurator.configure()

        return true
    }
}
