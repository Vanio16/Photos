//
//  Copyright © 2021 none. All rights reserved.
//

import UIKit

final class PhotosModel: Decodable {
    var id: String
    var width: Int
    var height: Int
    var color: String
    var user: User
    var urls: Urls
    var uiColor: UIColor? {
        return .init(hexString: color)
    }
}

final class User: Decodable {
    var name: String
}

final class Urls: Decodable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

extension PhotosModel: Equatable {
    static func == (lhs: PhotosModel, rhs: PhotosModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.width == rhs.width &&
            lhs.height == rhs.height &&
            lhs.color == rhs.color &&
            lhs.user == rhs.user &&
            lhs.urls == rhs.urls &&
            lhs.uiColor == rhs.uiColor
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Urls: Equatable {
    static func == (lhs: Urls, rhs: Urls) -> Bool {
        return lhs.raw == rhs.raw &&
            lhs.full == rhs.full &&
            lhs.regular == rhs.regular &&
            lhs.small == rhs.small &&
            lhs.thumb == rhs.thumb
    }
}
