//
//  Copyright © 2021 none. All rights reserved.
//

import Foundation
import UIKit
import CollectionViewTools
import Kingfisher

final class ImageCollectionViewCellItem: CollectionViewDiffCellItem {

    private typealias Cell = ImageCollectionViewCell

    let diffIdentifier: String

    let reuseType: ReuseType = .class(Cell.self)

    private var authorName: String
    private var viewColor: UIColor?
    private var imageURL: String
    private var ratio: CGFloat

    init(authorName: String, viewColor: UIColor?, imageURL: String, ratio: CGFloat) {
        self.authorName = authorName
        self.imageURL = imageURL
        self.viewColor = viewColor
        self.ratio = ratio
        diffIdentifier = UUID().uuidString
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.authorNameLabel.text = authorName
        cell.backgroundColorView.backgroundColor = viewColor
        let url = URL(string: imageURL)
        cell.imageView.kf.setImage(with: url)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width / ratio)
    }

    func isEqual(to item: DiffItem) -> Bool {
        guard let rhs = item as? ImageCollectionViewCellItem else {
            return false
        }

        let lhs = self
        return lhs.diffIdentifier == rhs.diffIdentifier &&
            lhs.authorName == rhs.authorName &&
            lhs.viewColor == rhs.viewColor &&
            lhs.imageURL == rhs.imageURL &&
            lhs.ratio == rhs.ratio
    }
}
