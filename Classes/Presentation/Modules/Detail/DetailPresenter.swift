//
//  Copyright © 2021 BitCom. All rights reserved.
//

final class DetailPresenter {

    typealias Dependencies = Any

    weak var view: DetailViewInput?
    weak var output: DetailModuleOutput?

    var state: DetailState
    private let dependencies: Dependencies

    init(state: DetailState,
         dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }
}

// MARK: - DetailViewOutput

extension DetailPresenter: DetailViewOutput {
    func closeScreenButtonTriggered() {
        output?.detailModuleClosed(self)
    }

    func viewDidLoad() {
        update(force: true, animated: true)
    }
}

// MARK: - DetailModuleInput

extension DetailPresenter: DetailModuleInput {

    func update(force: Bool = false, animated: Bool) {
        let viewModel = DetailViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
