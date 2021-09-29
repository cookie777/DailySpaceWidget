//
//  PanZoomImageView.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-19.
//

import UIKit

class PanZoomImageScrollView: UIScrollView {
  
  var doubleTapRecognizer: UITapGestureRecognizer!
  
  var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = false
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
//    contentInsetAdjustmentBehavior = .never
    setUpZoom()
    setUpUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func setUpZoom() {
    // Setup scroll view
    minimumZoomScale = 1
    maximumZoomScale = 4
    
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    
    delegate = self
    
    doubleTapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(handleDoubleTap(_:))
    )
    doubleTapRecognizer.numberOfTapsRequired = 2
    addGestureRecognizer(doubleTapRecognizer)
  }
  
  private func setUpUI() {
    backgroundColor = .black
    
    addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: widthAnchor),
      imageView.heightAnchor.constraint(equalTo: heightAnchor),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
  }
  
  @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
    if zoomScale == 1 {
      setZoomScale(2, animated: true)
    } else {
      setZoomScale(1, animated: true)
    }
  }
  
}

extension PanZoomImageScrollView: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
