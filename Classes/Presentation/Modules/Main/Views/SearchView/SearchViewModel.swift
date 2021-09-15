//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation

final class SearchViewModel: Equatable {
    var isCancelButtonHidden: Bool
    var activeTextFieldHandler: (() -> Void)?
    var cancelButtonHandler: (() -> Void)?

    init(isCancelButtonHidden: Bool) {
        self.isCancelButtonHidden = isCancelButtonHidden
    }

    static func == (lhs: SearchViewModel, rhs: SearchViewModel) -> Bool {
        return lhs.isCancelButtonHidden == rhs.isCancelButtonHidden
    }
}
