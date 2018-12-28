//
//  ClientLogger.swift
//  ClientLoggerExample
//
//  Created by Vladimir Vasilev on 26/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

private let sharedDateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "[yyyy-MM-dd HH:mm:ss]"

  return dateFormatter
}()

public class ClientLogger: NSObject {

  static public let defaultLogFile: String = "DefaultLog"

  static private var activated: Bool = false {
    didSet {
      if writingEnabled {
        for block in blocks {
          block()
        }
      } else {
        blocks.removeAll()
      }
    }
  }
  static public private(set) var writingEnabled: Bool = false
  static private var blocks: [() -> Void] = []

  static private let accessQueue = DispatchQueue(label: "LogsAccess")

  // MARK: Activation

  static public func activate(writeLogs: Bool) {
    writingEnabled = writeLogs
    activated = true
  }

  // MARK: Write

  static public func writeLineToDefaultLogFile(_ string: String) {
    writeLine(string, toFile: defaultLogFile)
  }

  static public func writeLine(_ string: String, toFile: String) {

    func write() {
      guard let logs = logsPath,
        let filePath = pathToFile(toFile) else { return }

      if !FileManager.default.fileExists(atPath: logs) {
        do {
          try FileManager.default.createDirectory(atPath: logs, withIntermediateDirectories: false, attributes: [:])
        } catch let error {
          print(error)

          return
        }
      }

      if !FileManager.default.fileExists(atPath: filePath) {
        do {
          try "".write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch let error {
          print(error)

          return
        }
      }

      accessQueue.sync {
        let fileHandle = FileHandle(forWritingAtPath: filePath)
        fileHandle?.seekToEndOfFile()

        let str = "\(sharedDateFormatter.string(from: Date())) \(string)\n"

        if let data = str.data(using: .utf8) {
          fileHandle?.write(data)
        }

        fileHandle?.closeFile()
      }
    }

    if activated {
      if writingEnabled {
        write()
      }
    } else {
      blocks.append(write)
    }
  }

  // MARK: Read

  static public func readDefaultLogFile(completion: @escaping (String?) -> Void) {
    return readLogFromFile(defaultLogFile, completion: completion)
  }

  static public func readLogFromFile(_ file: String, completion: @escaping (String?) -> Void) {
    guard let filePath = pathToFile(file),
      FileManager.default.fileExists(atPath: filePath) else {
      completion(nil)

      return
    }

    accessQueue.sync {
      do {
        let str = try String(contentsOfFile: filePath, encoding: .utf8)

        DispatchQueue.main.async {
          completion(str)
        }
      } catch let error {
        print(error)

        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
  }

  // MARK: Data

  static public func defaultLogFileData(completion: @escaping (Data?) -> Void) {
    return logDataFromFile(defaultLogFile, completion: completion)
  }

  static public func logDataFromFile(_ file: String, completion: @escaping (Data?) -> Void) {
    guard let filePath = pathToFile(file),
      FileManager.default.fileExists(atPath: filePath) else {
      completion(nil)

      return
    }

    accessQueue.sync {
      do {
        let str = try String(contentsOfFile: filePath, encoding: .utf8)
        let data = str.data(using: .utf8)

        DispatchQueue.main.async {
          completion(data)
        }
      } catch let error {
        print(error)

        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
  }

  // MARK: Remove

  static public func removeDefaultLogFile() {
    removeLogFile(defaultLogFile)
  }

  static public func removeLogFile(_ file: String) {
    guard let filePath = pathToFile(file),
      FileManager.default.fileExists(atPath: filePath) else { return }

    accessQueue.sync {
      do {
        try FileManager.default.removeItem(atPath: filePath)
      } catch let error {
        print(error)
      }
    }
  }

  // MARK: Open Log

  static public func add5TapsGestureToView(_ view: UIView) -> UITapGestureRecognizer {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openLogs))
    gestureRecognizer.numberOfTapsRequired = 5
    view.addGestureRecognizer(gestureRecognizer)

    return gestureRecognizer
  }

  static public func add2SecondsTapGestureToView(_ view: UIView) -> UILongPressGestureRecognizer {
    let gestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                         action: #selector(handleLongPressGestureRecognizer))
    gestureRecognizer.minimumPressDuration = 2.0
    view.addGestureRecognizer(gestureRecognizer)

    return gestureRecognizer
  }

  @objc
  static private func handleLongPressGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
    if gestureRecognizer.state == .began {
      ClientLogger.openLogs()
    }
  }

  @objc
  static public func openLogs() {
    let vc = ClientLoggerListViewController()
    let nc = UINavigationController(rootViewController: vc)
    nc.navigationBar.isTranslucent = false
    nc.navigationBar.isOpaque = true
    nc.modalPresentationStyle = .overCurrentContext
    nc.modalTransitionStyle = .coverVertical
    UIApplication.shared.keyWindow?.rootViewController?.present(nc, animated: true, completion: nil)
  }

  // MARK: Others

  static var logsList: [String] {
    guard let logs = logsPath else { return [] }

    var logsList: [String] = []

    do {
      logsList = try FileManager.default.contentsOfDirectory(atPath: logs)
    } catch let error {
      print(error)
    }

    return logsList
  }

  static private func documentsPathWithPathComponent(_ pathComponent: String) -> String? {
    guard let documentsPath =
      NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
      return nil
    }

    return "\(documentsPath)/\(pathComponent)"
  }

  static private var logsPath: String? {
    return documentsPathWithPathComponent("logs")
  }

  static private func pathToFile(_ file: String) -> String? {
    guard let logs = logsPath else { return nil }

    return "\(logs)/\(file.replacingOccurrences(of: "/", with: ""))"
  }

}