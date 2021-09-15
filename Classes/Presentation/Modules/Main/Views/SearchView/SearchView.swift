//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit

class SearchView: UIView {

    private var viewModel: SearchViewModel

    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 15
        return view
    }()

    let magnifierImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .white
        return imageView
    }()

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Search photos",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.addTarget(self, action: #selector(didBeginTextChange), for: .editingDidBegin)
        textField.background = .none
        return textField
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        add(backgroundView, magnifierImageView, searchTextField, cancelButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        if viewModel.isCancelButtonHidden {
            backgroundView.configureFrame { maker in
                maker.top()
                    .bottom()
                    .left(inset: 10)
                    .right(inset: 10)
            }

            magnifierImageView.configureFrame { maker in
                maker.left(to: backgroundView.nui_left, inset: 10)
                    .centerY(to: backgroundView.nui_centerY)
                    .size(width: frame.height - 40, height: frame.height - 40)
            }

            searchTextField.configureFrame { maker in
                maker.top(to: backgroundView.nui_top)
                    .left(to: magnifierImageView.nui_right, inset: 5)
                    .right(to: backgroundView.nui_right)
                    .bottom(to: backgroundView.nui_bottom)
            }

            cancelButton.configureFrame { maker in
                maker.sizeToFit()
                    .left(to: nui_right)
                    .centerY()
            }
        }
        else {
            backgroundView.configureFrame { maker in
                maker.top()
                    .bottom()
                    .left(inset: 10)
                    .right(inset: 80)
            }

            magnifierImageView.configureFrame { maker in
                maker.left(to: backgroundView.nui_left, inset: 10)
                    .centerY(to: backgroundView.nui_centerY)
                    .size(width: frame.height - 40, height: frame.height - 40)
            }

            searchTextField.configureFrame { maker in
                maker.top(to: backgroundView.nui_top)
                    .left(to: magnifierImageView.nui_right, inset: 5)
                    .right(to: backgroundView.nui_right)
                    .bottom(to: backgroundView.nui_bottom)
            }

            cancelButton.configureFrame { maker in
                maker.sizeToFit()
                    .left(to: backgroundView.nui_right, inset: 10)
                    .centerY()
            }
        }
    }

    @objc func cancelButtonPressed() {
        viewModel.cancelButtonHandler?()
    }

    @objc func didBeginTextChange() {
        viewModel.activeTextFieldHandler?()
    }
}

extension SearchView: ViewUpdate {
    func update(with viewModel: SearchViewModel, force: Bool, animated: Bool) {
        let oldViewModel = self.viewModel
        self.viewModel = viewModel

        func updateViewModel<Value: Equatable>(_ keyPath: KeyPath<SearchViewModel, Value>, configurationBlock: (Value) -> Void) {
            update(new: viewModel, old: oldViewModel, keyPath: keyPath, force: force, configurationBlock: configurationBlock)
        }

        updateViewModel(\.isCancelButtonHidden) { isHidden in
            UIView.animate(withDuration: 0.3, animations: {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            })
            if isHidden {
                searchTextField.text = ""
                endEditing(true)
            }
        }
    }
}
