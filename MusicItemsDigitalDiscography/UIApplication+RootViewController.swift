//
//  UIApplication+RootViewController.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 20.04.2024.
//

import Foundation
import UIKit

extension UIApplication {
  var currentKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow }
      .first
  }

  var rootViewController: UIViewController? {
    currentKeyWindow?.rootViewController
  }
}
