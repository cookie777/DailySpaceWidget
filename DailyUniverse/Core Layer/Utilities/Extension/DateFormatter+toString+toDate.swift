//
//  DateFormatter+toString+toDate.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-23.
//

import Foundation

extension DateFormatter {
  /// Date -> "d MMM y",  12 Aug 2021
  static func toStringForView(date: Date?) -> String? {
    guard let date = date else { return nil }
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM y"
    return formatter.string(from: date)
  }
  
  /// Date -> "d MMM y",  12 Aug 2021
  static func toStringForAPI(date: Date?) -> String? {
    guard let date = date else { return nil }
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  /// String "yyyy-MM-dd" -> Date
  static func toDate(string: String?) -> Date? {
    guard let string = string else { return nil }
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: string)
  }
}
