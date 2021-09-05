//
//  DateFormatter+toString+toDate.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-23.
//

import Foundation

struct Formatter {
  /// Date -> "d MMM y",  12 Aug 2021
  static func dateToStringForApp(date: Date?) -> String? {
    guard let date = date else { return nil }
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM y"
    return formatter.string(from: date)
  }
  
  /// Date -> "d MMM",  12 Aug
  static func dateToStringForWidget(date: Date?) -> String? {
    guard let date = date else { return nil }
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM"
    return formatter.string(from: date)
  }
  
  /// Date -> "d MMM y",  12 Aug 2021
  static func dateToStringForAPI(date: Date?) -> String? {
    guard let date = date else { return nil }
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  /// String "yyyy-MM-dd" -> Date
  static func stringToDate(string: String?) -> Date? {
    guard let string = string else { return nil }
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: string)
  }
  
  /// String "person" -> String "©NASA & person"
  static func copyrightWithNASA(string: String?) -> String {
    if let string = string {
      return "©NASA & \(string)"
    } else {
      return "©NASA"
    }
  }
}

