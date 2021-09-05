//
//  MainWidget.swift
//  MainWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-25.
//

import WidgetKit
import SwiftUI
import Intents
import RxSwift

struct Provider: IntentTimelineProvider {
  
  public typealias Entry = PhotoMetadataEntry
  
  let viewModel = WidgetViewModel(
    photoStorageService: PhotoStorageServiceImplementation(),
    photoFetchService: PhotosFetchServiceImplementation()
  )
  let disposeBag = DisposeBag()
  
  // place holder with no data
  func placeholder(in context: Context) -> PhotoMetadataEntry {
    return PhotoMetadataEntry.placeholder
  }
  
  // place holder with data
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (PhotoMetadataEntry) -> ()) {
    let entry = PhotoMetadataEntry.snapshot
    completion(entry)
  }
  
  // when to update and what to display?
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    debugPrint("✅ timeline start")
    
    let midnight = Calendar.current.startOfDay(for: Date())
    let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    //    let current = Date()
    //    let next = Calendar.current.date(byAdding: .minute, value: 4, to: current)!
    var entries: [PhotoMetadataEntry] = []
    
    viewModel.getItem()
      .bind { uiImage, metadata in
        // alternative image
        let image = (uiImage == nil) ?
          Image(uiImage: Constant.UI.placeholderImage) : Image(uiImage: uiImage!)
        
        let entry = PhotoMetadataEntry(
          date: Date(),
          data: metadata,
          image: image,
          configuration: configuration
        )
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
      }.disposed(by: disposeBag)
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
