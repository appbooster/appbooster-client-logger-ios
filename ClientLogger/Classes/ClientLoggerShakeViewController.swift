//
//  ClientLoggerShakeViewController.swift
//  ClientLoggerExample
//
//  Created by Vladimir Vasilev on 27/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

public class ClientLoggerShakeViewController: UIViewController {

  public var file: String = ClientLogger.defaultLogFile

  // MARK: UIResponder

  override public var canBecomeFirstResponder: Bool {
    return true
  }

  override public func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      ClientLogger.openLogs()
    }
  }

  // MARK: UIViewController

  override public func viewDidLoad() {
    super.viewDidLoad()

    becomeFirstResponder()
  }

}
