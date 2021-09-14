//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setHidden(_ isHidden: Bool,
                   animated: Bool,
                   animationDuration: TimeInterval = 0.3,
                   completion: ((_ finished: Bool) -> Void)? = nil) {
        layer.removeAllAnimations()
        if animated {
            if isHidden {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.alpha = 0
                }, completion: { finished in
                    if finished {
                        self.isHidden = isHidden
                        self.alpha = 1
                    }
                    completion?(finished)
                })
            }
            else {
                alpha = 0
                self.isHidden = false
                UIView.animate(withDuration: animationDuration, animations: {
                    self.alpha = 1
                }, completion: { finished in
                    completion?(finished)
                })
            }
        }
        else {
            self.isHidden = isHidden
            alpha = isHidden ? 0 : 1
            completion?(true)
        }
    }
}
