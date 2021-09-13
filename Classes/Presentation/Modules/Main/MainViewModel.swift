//
//  Copyright © 2021 BitCom. All rights reserved.
//

import CollectionViewTools

final class MainViewModel {

    let listSectionItems: [GeneralCollectionViewDiffSectionItem]
    let isActivityIndicatorHidden: Bool
    let isNetworkErrorViewHidden: Bool

    init(state: MainState, listItemsFactory: MainListItemsFactory) {
        listSectionItems = listItemsFactory.makeSectionItems(state: state)
        isActivityIndicatorHidden = state.isActivityIndicatorHidden
        isNetworkErrorViewHidden = state.isNetworkErrorViewHidden
    }
}
