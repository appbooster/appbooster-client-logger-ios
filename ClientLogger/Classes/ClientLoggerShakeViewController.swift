//
//  ClientLoggerShakeViewController.swift
//  ClientLoggerExample
//
//  Created by Vladimir Vasilev on 27/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

open class ClientLoggerShakeViewController: UIViewController {

  open var file: String = ClientLogger.defaultLogFile

  // MARK: UIResponder

  override open var canBecomeFirstResponder: Bool {
    return true
  }

  override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      ClientLogger.openLogs()
    }
  }

  // MARK: UIViewController

  override open func viewDidLoad() {
    super.viewDidLoad()

    becomeFirstResponder()
  }

}
