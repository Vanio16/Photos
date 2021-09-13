//
//  Copyright © 2021 none. All rights reserved.
//

import UIKit

final class NetworkErrorView: UIView {
    var retryButtonHandler: (() -> Void)?

    private struct Constants {
        static let networkErrorViewInsetLeft: CGFloat = 50
        static let networkErrorViewInsetRight: CGFloat = 50
        static let errorMessageHeaderLabelInsetTop: CGFloat = 20
        static let errorMessageLabelInsetRight: CGFloat = 30
        static let errorMessageLabelInsetLeft: CGFloat = 30
        static let errorMessageLabelInsetTop: CGFloat = 20
        static let retryButtonInsetTop: CGFloat = 30
        static let retryButtonSize = CGSize(width: 180, height: 50)
    }

    let networkErrorView: UIView = {
        let view = UIView()
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

    private let errorMessageHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Woah!"
        label.font = UIFont(name: "Lato-Bold", size: 26)
        return label
    }()

    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong. We're already working on that"
        label.font = UIFont(name: "Lato-Regular", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label

    }()

    init() {
        super.init(frame: .zero)
        networkErrorView.add(errorMessageHeaderLabel, errorMessageLabel, retryButton)
        add(networkErrorView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        networkErrorView.configureFrame { maker in
            let height = frame.width - (Constants.networkErrorViewInsetLeft + Constants.networkErrorViewInsetRight)
            maker.center()
                .left(inset: Constants.networkErrorViewInsetLeft)
                .right(inset: Constants.networkErrorViewInsetRight)
                .height(height - 50)
        }
        errorMessageHeaderLabel.configureFrame { maker in
            maker.centerX()
                .top(inset: Constants.errorMessageHeaderLabelInsetTop)
                .sizeToFit()
        }
        errorMessageLabel.configureFrame { maker in
            maker.left(inset: Constants.errorMessageLabelInsetLeft)
                .right(inset: Constants.errorMessageLabelInsetRight)
                .centerX()
                .top(to: errorMessageHeaderLabel.nui_bottom, inset: Constants.errorMessageLabelInsetTop)
                .heightToFit()
        }
        retryButton.configureFrame { maker in
            maker.top(to: errorMessageLabel.nui_bottom, inset: Constants.retryButtonInsetTop)
                .centerX()
                .size(Constants.retryButtonSize)
        }
    }

    @objc private func retryButtonPressed() {
        retryButtonHandler?()
    }
}
