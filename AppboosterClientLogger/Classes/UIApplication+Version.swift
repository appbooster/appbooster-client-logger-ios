//
//  UIApplication+Version.swift
//  AppboosterClientLogger
//
//  Created by Appbooster on 27/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

public extension UIApplication {

  static let appVersion: String =
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

}
