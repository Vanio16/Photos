//
//  Copyright © 2021 BitCom. All rights reserved.
//

final class MainPresenter {

    typealias Dependencies = Any

    weak var view: MainViewInput?
    weak var output: MainModuleOutput?

    var state: MainState
    private let networkService = NetworkService()
    private let dependencies: Dependencies
    private let listItemsFactory: MainListItemsFactory

    init(state: MainState,
         dependencies: Dependencies,
         listItemsFactory: MainListItemsFactory) {
        self.state = state
        self.dependencies = dependencies
        self.listItemsFactory = listItemsFactory
    }

}

// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {
    func didScrollToPageEnd() {
        state.page += 1
        networkService.getPhotos(page: state.page) { [weak self] result in
            switch result {
            case .success(let responce):
                self?.state.photos += responce
                self?.update(animated: true)
            case .failure(_):
                break
            }
        }
        update(force: true, animated: false)
    }

    func viewDidLoad() {
        networkService.getPhotos(page: state.page) { [weak self] result in
            switch result {
            case .success(let responce):
                self?.state.photos = responce
                self?.state.isActivityIndicatorHidden = true
                self?.update(animated: true)
            case .failure(_):
                break
            }
        }
        update(force: true, animated: false)
    }

}

// MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {

    func update(force: Bool = false, animated: Bool) {
        let viewModel = MainViewModel(state: state, listItemsFactory: listItemsFactory)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
