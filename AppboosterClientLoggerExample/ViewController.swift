//
//  ViewController.swift
//  AppboosterClientLoggerExample
//
//  Created by Appbooster on 26/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

/* To use shake gesture to open log just inherit from ClientLoggerShakeViewController and define file property */

class ViewController: AppboosterClientLoggerShakeViewController {

  @IBOutlet private weak var defaultTextView: UITextView!
  @IBOutlet private weak var customTextView: UITextView!

  private let customFile: String = "YourFile"

  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    /* Add 5 taps gesture to view to open log */

    _ = AppboosterClientLogger.add5TapsGestureToView(view)

    /* Add 2 seconds long press gesture to view to open log */

    _ = AppboosterClientLogger.add2SecondsPressGestureToView(view)
  }

  // MARK: Actions

  @IBAction private func writeToDefault() {

    /* Write line to default log */

    AppboosterClientLogger.writeLineToDefaultLogFile("Something To Default At \(Date())")
  }

  @IBAction private func writeToCustom() {

    /* Write line to custom log */

    AppboosterClientLogger.writeLine("Something To YourFile At \(Date())", toFile: customFile)
  }

  @IBAction private func readFromDefault() {

    /* Read log from default log */

    AppboosterClientLogger.readDefaultLogFile(completion: { [weak self] log in
      self?.defaultTextView.text = log
    })
  }

  @IBAction private func readFromCustom() {

    /* Read log from custom log */

    AppboosterClientLogger.readLogFromFile(customFile, completion: { [weak self] log in
      self?.customTextView.text = log
    })
  }

  @IBAction private func removeDefault() {

    /* Remove default log */

    AppboosterClientLogger.removeDefaultLogFile()
  }

  @IBAction private func removeCustom() {

    /* Remove custom log */

    AppboosterClientLogger.removeLogFile(customFile)
  }

  @IBAction private func openLogs() {

    /* Open logs */

    AppboosterClientLogger.openLogs()
  }

}
