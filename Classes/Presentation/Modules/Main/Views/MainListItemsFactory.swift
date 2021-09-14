//
//  Copyright © 2021 BitCom. All rights reserved.
//

import CollectionViewTools

final class MainListItemsFactory {

    weak var viewController: MainViewController?
    weak var output: MainViewOutput?

    func makeSectionItems(state: MainState) -> [GeneralCollectionViewDiffSectionItem] {
        var cellItems: [CollectionViewDiffCellItem] = []
        if state.photos.isEmpty {
            return []
        }
        for photo in state.photos {
            let ratio = CGFloat(photo.width) / CGFloat(photo.height)
            let item = ImageCollectionViewCellItem(authorName: photo.user.name,
                                                   viewColor: photo.uiColor,
                                                   imageURL: photo.urls.regular,
                                                   ratio: CGFloat(ratio))
            item.itemDidSelectHandler = { [weak self] _ in
                self?.output?.showDetailScreen(photo: photo, ratio: ratio)
            }
            cellItems.append(item)
        }
        let item = ActivityCollectionViewCellItem()
        cellItems.append(item)
        let sectionItem = GeneralCollectionViewDiffSectionItem(cellItems: cellItems)
        return [sectionItem]
    }
}
