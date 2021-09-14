//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit
import CollectionViewTools
import Kingfisher

final class ActivityCollectionViewCellItem: CollectionViewDiffCellItem {

    private typealias Cell = ActivityCollectionViewCell

    let diffIdentifier: String

    let reuseType: ReuseType = .class(Cell.self)

    init() {
        diffIdentifier = UUID().uuidString
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }

    func isEqual(to item: DiffItem) -> Bool {
        guard let rhs = item as? ActivityCollectionViewCellItem else {
            return false
        }

        let lhs = self
        return lhs.diffIdentifier == rhs.diffIdentifier
    }
}
