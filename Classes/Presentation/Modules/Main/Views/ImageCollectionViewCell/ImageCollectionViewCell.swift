//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit
import Framezilla

class ImageCollectionViewCell: UICollectionViewCell {
    private struct Constants {
        static let authorNameLabelLeftInset: CGFloat = 4
        static let authorNameLabelBottomInset: CGFloat = 20
        static let gradientViewTopInset: CGFloat = -40
    }

    private(set) lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Lato-Regular", size: 17)
        return label
    }()

    private let gradientView = UIView()

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        let colorTop =  UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
       return gradientLayer
    }()

    private(set) lazy var view = UIView()

    private(set) lazy var image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        gradientView.layer.addSublayer(gradientLayer)

        add(view, image, gradientView, authorNameLabel)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        authorNameLabel.configureFrame { maker in
            maker.right()
                .left(inset: Constants.authorNameLabelLeftInset)
                .bottom(inset: Constants.authorNameLabelBottomInset)
                .heightToFit()
        }

        view.configureFrame { maker in
            maker.top()
                .bottom()
                .right()
                .left()
        }

        image.configureFrame { maker in
            maker.top()
                .bottom()
                .left()
                .right()
        }
        gradientView.configureFrame { maker in
            maker.left()
                .right()
                .bottom()
                .top(to: authorNameLabel.nui_top, inset: Constants.gradientViewTopInset)
        }
        gradientLayer.frame = gradientView.bounds
    }
}
