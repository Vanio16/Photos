//
//  Copyright © 2021 BitCom. All rights reserved.
//

import UIKit
import CollectionViewTools
import Framezilla

protocol MainViewInput: AnyObject {
    func update(with viewModel: MainViewModel, force: Bool, animated: Bool)
}

protocol MainViewOutput: AnyObject {
    func viewDidLoad()
    func didScrollToPageEnd()
    func retryButtonTriggered()
    func changeTextFieldFocused(_ isFocused: Bool)
    func showDetailScreen(photo: PhotosModel, ratio: CGFloat)
}

final class MainViewController: UIViewController {

    private var viewModel: MainViewModel
    private let output: MainViewOutput

    private lazy var collectionViewManager: CollectionViewManager = {
        let manager = CollectionViewManager(collectionView: collectionView)
        manager.scrollDelegate = self
        return manager
    }()
    // MARK: - Subviews

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        view.isPrefetchingEnabled = false
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()

    private lazy var networkErrorView: NetworkErrorView = {
        let view = NetworkErrorView()
        view.retryButtonHandler = { [weak output] in
            output?.retryButtonTriggered()
        }
        return view
    }()

    private lazy var searchView: SearchView = .init(viewModel: viewModel.searchViewModel)

    private let offersView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    // MARK: - Lifecycle

    init(viewModel: MainViewModel, output: MainViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.add(searchView, activityIndicator, collectionView, offersView, networkErrorView)
        output.viewDidLoad()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        searchView.configureFrame { maker in
            maker.top(inset: 10 + view.safeAreaInsets.top)
                .left()
                .right()
                .height(60)
        }

        offersView.configureFrame { maker in
            maker.top(to: searchView.nui_bottom, inset: 10)
                .left()
                .right()
                .bottom(inset: view.safeAreaInsets.bottom)
        }

        collectionView.configureFrame { maker in
            maker.top(to: searchView.nui_bottom, inset: 10)
                .left()
                .right()
                .bottom(inset: view.safeAreaInsets.bottom)
        }

        activityIndicator.configureFrame { maker in
            maker.center()
        }

        networkErrorView.configureFrame { maker in
            maker.center()
                .size(width: view.frame.width, height: view.frame.width)
        }
    }
}

// MARK: - MainViewInput

extension MainViewController: MainViewInput, ViewUpdate {

    func update(with viewModel: MainViewModel, force: Bool, animated: Bool) {
        let oldViewModel = self.viewModel
        self.viewModel = viewModel

        func updateViewModel<Value: Equatable>(_ keyPath: KeyPath<MainViewModel, Value>, configurationBlock: (Value) -> Void) {
            update(new: viewModel, old: oldViewModel, keyPath: keyPath, force: force, configurationBlock: configurationBlock)
        }

        updateViewModel(\.isActivityIndicatorHidden) { isHidden in
            isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        }

        updateViewModel(\.isNetworkErrorViewHidden) { isHidden in
            networkErrorView.isHidden = isHidden
        }

        updateViewModel(\.isOffersViewHidden) { isHidden in
            offersView.setHidden(isHidden, animated: true)
        }

        updateViewModel(\.searchViewModel) { searchViewModel in
            searchView.update(with: searchViewModel, force: force, animated: animated)
        }

        collectionViewManager.update(with: viewModel.listSectionItems, animated: animated)
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY >= (scrollView.contentSize.height - scrollView.bounds.height - 19) {
            output.didScrollToPageEnd()
        }
    }
}
