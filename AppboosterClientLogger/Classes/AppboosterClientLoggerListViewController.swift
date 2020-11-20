//
//  AppboosterClientLoggerListViewController.swift
//  AppboosterClientLogger
//
//  Created by Appbooster on 28/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

enum ClearOption: CaseIterable {

  case userDefaults
  case keychain
  case urlCache
  case cookies
  case files
  case all

  var title: String {
    switch self {
    case .userDefaults: return "User Defaults"
    case .keychain: return "Keychain"
    case .urlCache: return "URL Cache"
    case .cookies: return "Cookies"
    case .files: return "Files"
    case .all: return "All"
    }
  }

  func clear() {
    switch self {
    case .userDefaults: clearUserDefaults()
    case .keychain: clearKeychain()
    case .urlCache: clearURLCache()
    case .cookies: clearCookies()
    case .files: clearFiles()
    case .all: clearAll()
    }
  }

}

class AppboosterClientLoggerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  private var tableView: UITableView!

  private let cellIdentifier: String = "FileCell"

  private var files: [String] = []

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Version \(UIApplication.appVersion)"

    let closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
    let clearBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clear))

    navigationItem.setLeftBarButton(closeBarButton, animated: false)
    navigationItem.setRightBarButton(clearBarButton, animated: false)

    tableView = UITableView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)

    refreshLogs()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    tableView.frame = view.bounds
  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return files.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    cell.selectionStyle = .none
    cell.textLabel?.text = files[indexPath.row]

    return cell
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = AppboosterClientLoggerViewController()
    vc.file = files[indexPath.row]
    vc.reloadList = refreshLogs
    navigationController?.pushViewController(vc, animated: true)
  }

  // MARK: - Others

  @objc
  private func close() {
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func clear() {
    showChoiceActionSheet()
  }

  private func refreshLogs() {
    files = AppboosterClientLogger.logsList
    tableView.reloadData()
  }

  private func showChoiceActionSheet() {
    let alertController = UIAlertController(title: "What do you want to clear?",
                                            message: nil,
                                            preferredStyle: .actionSheet)

    ClearOption.allCases.forEach({ option in
      let action = UIAlertAction(title: option.title, style: .default) { [unowned self] _ in
        self.showConfirmationDialog(clearOption: option)
      }
      alertController.addAction(action)
    })

    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAlertAction)

    present(alertController, animated: true, completion: nil)
  }

  private func showConfirmationDialog(clearOption: ClearOption) {
    let alertController = UIAlertController(title: "Warning",
                                            message: "Do you really want to clear \(clearOption.title.lowercased())?",
                                            preferredStyle: .alert)

    let action = UIAlertAction(title: "Clear", style: .destructive) { [unowned self] _ in
      clearOption.clear()

      self.showExitDialog()
    }
    alertController.addAction(action)

    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAlertAction)

    present(alertController, animated: true, completion: nil)
  }

  private func showExitDialog() {
    let alertController = UIAlertController(title: "Exit",
                                            message: "Do you want to exit the app?",
                                            preferredStyle: .alert)

    let action = UIAlertAction(title: "Exit", style: .destructive) { _ in
      exit(0)
    }
    alertController.addAction(action)

    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAlertAction)

    present(alertController, animated: true, completion: nil)
  }

}
