//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit

final class MainCoordinator: MainModuleOutput, DetailModuleOutput {

    let window: UIWindow
    var navigationController: UINavigationController
    let mainModule = MainModule()
    var detailModule: DetailModule?

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

    func detailModuleClosed(_ moduleInput: DetailModuleInput) {
    }

    func mainModuleDetailModuleShow(_ moduleInput: MainModuleInput, photo: PhotosModel, ratio: CGFloat) {
        let detailModule = DetailModule(state: .init(photo: photo, ratio: ratio))
        self.detailModule = detailModule
        self.detailModule?.output = self
        navigationController.pushViewController(detailModule.viewController, animated: true)
    }

    func detailModuleMainModuleShow(_ moduleInput: DetailModuleInput) {
        navigationController.popViewController(animated: true)
    }
}
