//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit
import Framezilla

class ActivityCollectionViewCell: UICollectionViewCell {
    private struct Constants {
    }

    private let activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.style = .medium
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        add(activityIndicator)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        activityIndicator.configureFrame { maker in
            maker.center()
        }
    }
}
