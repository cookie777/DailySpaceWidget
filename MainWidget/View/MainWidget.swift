//
//  MainWidget.swift
//  MainWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-25.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  
  public typealias Entry = PhotoMetadataEntry
  
  let viewModel = WidgetViewModel(
    photoStorageService: PhotoStorageServiceImplementation(),
    photoFetchService: PhotosFetchServiceImplementation()
  )
  // place holder with no data
  func placeholder(in context: Context) -> PhotoMetadataEntry {
    return PhotoMetadataEntry.placeholder
  }
  
  // This is used at previewing your widget
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (PhotoMetadataEntry) -> ()) {
    let entry = PhotoMetadataEntry.snapshot
    completion(entry)
  }
  
  // when to update and what to display?
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    debugPrint("✅ timeline start")
    
    //    let midnight = Calendar.current.startOfDay(for: Date())
    //    let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    let midnight = Date()
    let nextMidnight = Calendar.current.date(byAdding: .hour, value: 1, to: midnight)!
    print(midnight)
    print(nextMidnight)
    var entries: [PhotoMetadataEntry] = []
    
    let (uiImage, metadata) = viewModel.getItem()
    let image = (uiImage == nil) ?
    Image(uiImage: Constant.UI.placeholderImage) : Image(uiImage: uiImage!)

    let entry = PhotoMetadataEntry(
      date: Date(),
      data: metadata,
      image: image,
      configuration: configuration
    )
    entries.append(entry)
    print(image)

    let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
      completion(timeline)
  }
}


// combine all
@main
struct MainWidget: Widget {
  let kind: String = "MainWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(
      kind: kind,
      intent: ConfigurationIntent.self,
      provider: Provider()
    ) { entry in
      MainWidgetEntryView(entry: entry)
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
    .configurationDisplayName("DailySpaceWidget")
    .description("")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
