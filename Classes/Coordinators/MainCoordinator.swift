//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit

final class MainCoordinator: MainModuleOutput {

    let window: UIWindow
    var navigationController: UINavigationController
    let mainModule = MainModule()

    init(window: UIWindow) {
        self.window = window
        navigationController = .init(rootViewController: mainModule.viewController)
        navigationController.navigationBar.isHidden = true
    }

    func start() {
        mainModule.output = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func mainModuleClosed(_ moduleInput: MainModuleInput) {
    }
}
