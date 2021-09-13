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

    let networkErrorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()

    private let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 24)
        button.addTarget(self, action: #selector(retryButtonPressed), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        return button
    }()

    private let errorMessageHeader: UILabel = {
        let label = UILabel()
        label.text = "Woah!"
        label.font = UIFont(name: "Lato-Bold", size: 26)
        return label
    }()

    private let errorMessage: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong. We're already working on that"
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label

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
        networkErrorView.add(errorMessageHeader, errorMessage, retryButton)
        view.add(collectionView, activityIndicator, networkErrorView)

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

        networkErrorView.configureFrame { maker in
            let height = view.frame.width - 100
            maker.center()
                .left(inset: 50)
                .right(inset: 50)
                .height(height - 50)
        }
        errorMessageHeader.configureFrame { maker in
            maker.centerX()
                .top(inset: 20)
                .sizeToFit()
        }
        errorMessage.configureFrame { maker in
            maker.left(inset: 30)
                .right(inset: 30)
                .centerX()
                .top(to: errorMessageHeader.nui_bottom, inset: 20)
                .heightToFit()
        }
        retryButton.configureFrame { maker in
            maker.top(to: errorMessage.nui_bottom, inset: 30)
                .centerX()
                .size(width: 180, height: 50)
        }
    }
    @objc private func retryButtonPressed() {
        output.retryButtonTriggered()
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
