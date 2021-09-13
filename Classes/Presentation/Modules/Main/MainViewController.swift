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
        view.add(collectionView, activityIndicator)
        output.viewDidLoad()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.contentInset = view.safeAreaInsets
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        activityIndicator.configureFrame { maker in
            maker.center()
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
