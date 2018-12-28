//
//  ClientLoggerListViewController.swift
//  ClientLoggerExample
//
//  Created by Vladimir Vasilev on 28/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit

class ClientLoggerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  private var tableView: UITableView!

  private let cellIdentifier: String = "FileCell"

  private var files: [String] = []

  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Version \(UIApplication.appVersion)"

    let closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))

    navigationItem.setLeftBarButton(closeBarButton, animated: false)

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

  // MARK: UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return files.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    cell.selectionStyle = .none
    cell.textLabel?.text = files[indexPath.row]

    return cell
  }

  // MARK: UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = ClientLoggerViewController()
    vc.file = files[indexPath.row]
    vc.reloadList = refreshLogs
    navigationController?.pushViewController(vc, animated: true)
  }

  // MARK: Others

  @objc
  private func close() {
    dismiss(animated: true, completion: nil)
  }

  private func refreshLogs() {
    files = ClientLogger.logsList
    tableView.reloadData()
  }

}
