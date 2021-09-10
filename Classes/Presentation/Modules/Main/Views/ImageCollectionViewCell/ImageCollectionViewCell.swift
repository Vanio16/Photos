//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit
import Framezilla

class ImageCollectionViewCell: UICollectionViewCell {
    private struct Constants {
        static let meaningLabelLeftInset: CGFloat = 4
    }

    private(set) lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private(set) lazy var view = UIView()

    private(set) lazy var image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        add(view, image, authorNameLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        authorNameLabel.configureFrame { maker in
            maker.right()
                .left(inset: Constants.meaningLabelLeftInset)
                .bottom(inset: 20)
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
    }
}
