//
//  Copyright © 2021 BitCom. All rights reserved.
//

import CollectionViewTools

final class DetailViewModel {
    var photo: PhotosModel
    var ratio: CGFloat = 0

    init(state: DetailState) {
        self.photo = state.photo
        self.ratio = state.ratio
    }
}
