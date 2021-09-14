//
//  Copyright © 2021 BitCom. All rights reserved.
//

import CollectionViewTools

final class MainViewModel {

    let listSectionItems: [GeneralCollectionViewDiffSectionItem]
    let isActivityIndicatorHidden: Bool
    let isNetworkErrorViewHidden: Bool
    let isOffersViewHidden: Bool
    let searchViewModel: SearchViewModel

    init(state: MainState, listItemsFactory: MainListItemsFactory, output: MainViewOutput) {
        listSectionItems = listItemsFactory.makeSectionItems(state: state)
        isActivityIndicatorHidden = state.isActivityIndicatorHidden
        isNetworkErrorViewHidden = state.isNetworkErrorViewHidden
        isOffersViewHidden = !state.isTextFieldFocused
        searchViewModel = .init(isCancelButtonHidden: !state.isTextFieldFocused)
        searchViewModel.activeTextFieldHandler = {
            output.changeTextFieldFocused(true)
        }
        searchViewModel.cancelButtonHandler = {
            output.changeTextFieldFocused(false)
        }
    }
}
