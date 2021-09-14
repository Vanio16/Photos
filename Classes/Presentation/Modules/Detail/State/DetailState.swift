//
//  Copyright © 2021 none. All rights reserved.
//
import UIKit

final class DetailState {
    var photo: PhotosModel
    var ratio: CGFloat = 0

    init(photo: PhotosModel, ratio: CGFloat) {
        self.photo = photo
        self.ratio = ratio
    }
}
