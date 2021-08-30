//
//  MainWidget.swift
//  MainWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-25.
//

import WidgetKit
import SwiftUI
import Intents
import Kingfisher
import RxSwift

struct Provider: IntentTimelineProvider {
  
  let viewModel = WidgetViewModel(
    photoStorageService: PhotoStorageServiceImplementation(),
    photoFetchService: PhotosFetchServiceImplementation()
  )
  let disposeBag = DisposeBag()
  
  func placeholder(in context: Context) -> PhotoMetadataEntry {
    
    return PhotoMetadataEntry(
      date: Date(),
      data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil),
      image: Image(systemName: "heart.fill"),
      configuration: ConfigurationIntent()
    )
    
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (PhotoMetadataEntry) -> ()) {
    let entry = PhotoMetadataEntry(
      date: Date(),
      data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil),
      image: Image(systemName: "heart.fill"),
      configuration: ConfigurationIntent()
    )
    completion(entry)
  }
  
  var count = 0
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    print("✅")
//    if viewModel.isFetching {
//      print("already fetching")
////      return
//    }
    viewModel.count += 1
    print(viewModel.count)
    print("start")
    
    let midnight = Calendar.current.startOfDay(for: Date())
    let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    let current = Date()
    let next = Calendar.current.date(byAdding: .minute, value: 4, to: current)!
    var entries: [PhotoMetadataEntry] = []
    
    viewModel.getImage().bind { uiImage in
      let image =  uiImage == nil ? Image(systemName: "pencil.tip.crop.circle.badge.plus") : Image(uiImage: uiImage!)
      for offset in 0...0 {
        let entry = PhotoMetadataEntry(
          date: Calendar.current.date(byAdding: .minute, value: offset, to: current)!,
          data: PhotoMetadata(
            copyright: nil,
            date: nil,
            explanation: nil,
            imageHDURL: nil,
            imageURL: nil,
            title: nil
          ),
          image: image,
          configuration: configuration
        )
        entries.append(entry)
      }
      
      let timeline = Timeline(entries: entries, policy: .after(next))
      completion(timeline)
    }.disposed(by: disposeBag)
//    viewModel.getImage() { uiImage in
//      let image =  uiImage == nil ? Image(systemName: "pencil.tip.crop.circle.badge.plus") : Image(uiImage: uiImage!)
//      for offset in 0...0 {
//        let entry = PhotoMetadataEntry(
//          date: Calendar.current.date(byAdding: .minute, value: offset, to: current)!,
//          data: PhotoMetadata(
//            copyright: nil,
//            date: nil,
//            explanation: nil,
//            imageHDURL: nil,
//            imageURL: nil,
//            title: nil
//          ),
//          image: image,
//          configuration: configuration
//        )
//        entries.append(entry)
//      }
//
//      let timeline = Timeline(entries: entries, policy: .after(next))
//      completion(timeline)
//    }
    
  }
}


struct PhotoMetadataEntry: TimelineEntry {
  var date: Date
  let data: PhotoMetadata
  var image: Image?
  let configuration: ConfigurationIntent
}

struct MainWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack {
      entry.image!
        .resizable()
        .scaledToFit()
      
      Text(entry.date.description)
    }
    
  }
}

@main
struct MainWidget: Widget {
  let kind: String = "MainWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      MainWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct MainWidget_Previews: PreviewProvider {
  static var previews: some View {
    MainWidgetEntryView(entry:  PhotoMetadataEntry(date: Date(), data: PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: nil, imageURL: nil, title: nil), configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
