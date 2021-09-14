//
//  Copyright © 2021 BitCom. All rights reserved.
//

import UIKit
import Framezilla
import Kingfisher

protocol DetailViewInput: AnyObject {
    func update(with viewModel: DetailViewModel, force: Bool, animated: Bool)
}

protocol DetailViewOutput: AnyObject {
    func viewDidLoad()
    func closeScreenButtonTriggered()
}

final class DetailViewController: UIViewController {
    private struct Constants {
        static let closeScreenButtonInsetTop: CGFloat = 4
        static let closeScreenButtonInsetLeft: CGFloat = 4
    }

    private var viewModel: DetailViewModel
    private let output: DetailViewOutput
    private var isElementsHidden = false

    // MARK: - Subviews

    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Lato-Regular", size: 18)
        return label
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private let closeScreenButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(closeScreenButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    init(viewModel: DetailViewModel, output: DetailViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.add(authorNameLabel, closeScreenButton, photoImageView)
        output.viewDidLoad()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeScreenButton.configureFrame { maker in
            maker.top(to: view.nui_safeArea.top, inset: Constants.closeScreenButtonInsetTop)
                .left(to: view.nui_safeArea.left, inset: Constants.closeScreenButtonInsetLeft)
                .size(width: 20, height: 20)
        }
        authorNameLabel.configureFrame { maker in
            maker.centerY(to: closeScreenButton.nui_centerY)
        }
    }

    private func layoutPhotoViewImage(ratio: CGFloat) {
        photoImageView.configureFrame { maker in
            maker.center()
                .size(width: view.frame.width, height: view.frame.width / ratio)
        }
    }

    // MARK: - Actions

    @objc private func closeScreenButtonPressed() {
        output.closeScreenButtonTriggered()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isElementsHidden = !isElementsHidden
        authorNameLabel.setHidden(isElementsHidden, animated: true)
        closeScreenButton.setHidden(isElementsHidden, animated: true)
    }
}

// MARK: - MainViewInput

extension DetailViewController: DetailViewInput, ViewUpdate {

    func update(with viewModel: DetailViewModel, force: Bool, animated: Bool) {
        let oldViewModel = self.viewModel
        self.viewModel = viewModel

        func updateViewModel<Value: Equatable>(_ keyPath: KeyPath<DetailViewModel, Value>, configurationBlock: (Value) -> Void) {
            update(new: viewModel, old: oldViewModel, keyPath: keyPath, force: force, configurationBlock: configurationBlock)
        }

        updateViewModel(\.photo) { photo in
            authorNameLabel.text = photo.user.name
            authorNameLabel.configureFrame { maker in
                maker.centerX()
                    .sizeToFit()
            }
            let url = URL(string: photo.urls.regular)
            photoImageView.kf.setImage(with: url)
        }
        updateViewModel(\.ratio) { ratio in
            layoutPhotoViewImage(ratio: ratio)
        }
    }
}
