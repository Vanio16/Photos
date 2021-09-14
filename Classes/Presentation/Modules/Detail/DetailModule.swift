//
//  Copyright © 2021 BitCom. All rights reserved.
//

protocol DetailModuleInput: AnyObject {

    var state: DetailState { get }
    func update(force: Bool, animated: Bool)
}

protocol DetailModuleOutput: AnyObject {

    func detailModuleClosed(_ moduleInput: DetailModuleInput)
}

final class DetailModule {

    var input: DetailModuleInput {
        return presenter
    }
    var output: DetailModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: DetailViewController
    private let presenter: DetailPresenter

    init(state: DetailState) {
        let presenter = DetailPresenter(state: state, dependencies: [Any]())
        let viewModel = DetailViewModel(state: state)
        let viewController = DetailViewController(viewModel: viewModel, output: presenter)
        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
