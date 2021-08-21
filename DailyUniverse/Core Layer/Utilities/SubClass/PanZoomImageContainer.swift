//
//  PanZoomImageView.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-19.
//

import UIKit

class PanZoomImageContainer: UIScrollView {
  
  var imageView = UIImageView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpUI()
  }
  
  private func setUpUI() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    addSubview(imageView)
    self.contentInsetAdjustmentBehavior = .never
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: widthAnchor),
      imageView.heightAnchor.constraint(equalTo: heightAnchor),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    // Setup scroll view
    minimumZoomScale = 1
    maximumZoomScale = 4
    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
  
    delegate = self
    
    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
    doubleTapRecognizer.numberOfTapsRequired = 2
    addGestureRecognizer(doubleTapRecognizer)
  }
  
  @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
    if zoomScale == 1 {
      setZoomScale(4, animated: true)
    } else {
      setZoomScale(1, animated: true)
    }
  }
  
}

extension PanZoomImageContainer: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
