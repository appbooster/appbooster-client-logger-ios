//
//  AppboosterClientLoggerListViewController.swift
//  AppboosterClientLogger
//
//  Created by Appbooster on 28/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

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
    showConfirmationAlert()
  }

  private func refreshLogs() {
    files = AppboosterClientLogger.logsList
    tableView.reloadData()
  }

  private func showConfirmationAlert() {
    let alertController = UIAlertController(title: "Warning",
                                            message: "Do you really want to clear all the data?",
                                            preferredStyle: .alert)

    let clearAlertAction = UIAlertAction(title: "Clear", style: .destructive) { [unowned self] _ in
      clearUserDefaults()
      clearKeychain()
      clearCookies()
      clearFiles()

      self.showExitAlert()
    }
    alertController.addAction(clearAlertAction)

    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAlertAction)

    present(alertController, animated: true, completion: nil)
  }

  private func showExitAlert() {
    let alertController = UIAlertController(title: """
Device token was reseted.
The app will be closed by tap on OK button.
""",
                                            message: nil,
                                            preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
      exit(0)
    }
    alertController.addAction(alertAction)

    present(alertController, animated: true, completion: nil)
  }

}