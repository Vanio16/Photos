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

    private func fetchPhotos() {
        state.isNetworkErrorViewHidden = true
        state.isActivityIndicatorHidden = false
        networkService.getPhotos(pageIndex: state.pageIndex) { [weak self] result in
            switch result {
            case .success(let response):
                self?.state.photos = response
                self?.state.isActivityIndicatorHidden = true
                self?.update(animated: true)
            case .failure(_):
                self?.state.isNetworkErrorViewHidden = false
                self?.state.isActivityIndicatorHidden = true
                self?.update(animated: true)
            }
        }
        update(force: true, animated: false)
    }
}

// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {
    func retryButtonTriggered() {
        fetchPhotos()
    }

    func didScrollToPageEnd() {
        state.pageIndex += 1
        networkService.getPhotos(pageIndex: state.pageIndex) { [weak self] result in
            switch result {
            case .success(let response):
                self?.state.photos += response
                self?.update(animated: true)
            case .failure(_):
                break
            }
        }
        update(force: true, animated: false)
    }

    func viewDidLoad() {
        fetchPhotos()
    }
}

// MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {

    func update(force: Bool = false, animated: Bool) {
        let viewModel = MainViewModel(state: state, listItemsFactory: listItemsFactory)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
