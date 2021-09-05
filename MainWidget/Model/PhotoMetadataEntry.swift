//
//  PhotoMetadataEntry.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-31.
//

import WidgetKit
import SwiftUI

// data model
struct PhotoMetadataEntry: TimelineEntry {
  var date: Date
  let data: PhotoMetadata?
  var image: Image
  let configuration: ConfigurationIntent?
}

extension PhotoMetadataEntry {
  
  static let placeholder = PhotoMetadataEntry(
    date: Date(),
    data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil),
    image: Image(""),
    configuration: ConfigurationIntent()
  )
  
  static let snapshot = PhotoMetadataEntry(
    date: Date(),
    data: PhotoMetadata(
      copyright: nil,
      date: Date(),
      explanation: nil,
      imageHDURL: nil,
      imageURL: nil,
      title: "Title of the photo"
    ),
    image: Image("Widget_mock"),
    configuration: ConfigurationIntent()
  )
  
  static let mock = PhotoMetadataEntry(
    date: Date(),
    data: PhotoMetadata(
      copyright: "@Robert Eder",
      date: Date(),
      explanation: "This is exp",
      imageHDURL: nil,
      imageURL: nil,
      title: "A Blue Moon in Exaggerated Colors"
    ),
    image: Image("Widget_mock"),
    configuration: nil
  )
  
}
