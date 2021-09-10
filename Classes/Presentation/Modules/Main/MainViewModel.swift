//
//  Copyright © 2021 BitCom. All rights reserved.
//

import CollectionViewTools

final class MainViewModel {

    let listSectionItems: [GeneralCollectionViewDiffSectionItem]

    init(state: MainState, listItemsFactory: MainListItemsFactory) {
        listSectionItems = listItemsFactory.makeSectionItems(state: state)
    }
}