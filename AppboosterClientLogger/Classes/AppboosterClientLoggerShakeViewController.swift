//
//  AppboosterClientLoggerShakeViewController.swift
//  AppboosterClientLogger
//
//  Created by Appbooster on 27/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

open class AppboosterClientLoggerShakeViewController: UIViewController {

  open var file: String = AppboosterClientLogger.defaultLogFile
  open weak var from: UIViewController?
  open var shakeGestureIsEnabled: Bool = true

  // MARK: - UIResponder

  override open var canBecomeFirstResponder: Bool {
    return true
  }

  override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if shakeGestureIsEnabled && motion == .motionShake {
      AppboosterClientLogger.openLogs(from: from ?? self)
    }
  }

  // MARK: - UIViewController

  override open func viewDidLoad() {
    super.viewDidLoad()

    becomeFirstResponder()
  }

}
