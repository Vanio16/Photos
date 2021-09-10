//
//  Copyright © 2021 BitCom. All rights reserved.
//

import CollectionViewTools

final class MainListItemsFactory {

    weak var viewController: MainViewController?
    weak var output: MainViewOutput?
    var cellItems: [ImageCollectionViewCellItem] = []

    func makeSectionItems(state: MainState) -> [GeneralCollectionViewDiffSectionItem] {

        for photo in state.photos {
            let ratio = CGFloat(photo.width) / CGFloat(photo.height)
            let item = ImageCollectionViewCellItem(authorName: photo.user.name,
                                                   viewColor: photo.uiColor,
                                                   imageURL: photo.urls.regular,
                                                   ratio: CGFloat(ratio))
            //            item.itemDidSelectHandler = { [weak self] _ in
            //
            //            }
            cellItems.append(item)
        }
        let sectionItem = GeneralCollectionViewDiffSectionItem(cellItems: cellItems)
        return [sectionItem]
    }
}
