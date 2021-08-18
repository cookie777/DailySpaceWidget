//
//  item.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-17.
//

import Foundation

enum Item: Hashable {
  case photo(Photo)
}

extension Item {
  /// Get `User` model from Item
  var photo: Photo? {
    get {
      if case let .photo(element) = self {
        return element
      } else {
        return nil
      }
    }
  }
  /// Wrap multi User model into Items
  static func wrap(items: [Photo]) -> [Item] {
    return items.map {Item.photo($0)}
  }
}
