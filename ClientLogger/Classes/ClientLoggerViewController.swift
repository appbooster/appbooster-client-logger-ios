//
//  ClientLoggerViewController.swift
//  ClientLoggerExample
//
//  Created by Vladimir Vasilev on 26/12/2018.
//  Copyright © 2018 Appbooster. All rights reserved.
//

import UIKit
import MessageUI

class ClientLoggerViewController: UIViewController, MFMailComposeViewControllerDelegate {

  private var textView: UITextView!
  private var activityIndicatorView: UIActivityIndicatorView!

  var file: String!
  var reloadList: (() -> Void)!

  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    let backBarButton = UIBarButtonItem(title: "←", style: .plain, target: self, action: #selector(back))
    let removeBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
    let mailBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(mail))
    let refreshBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    let downBarButton = UIBarButtonItem(title: "↓", style: .plain, target: self, action: #selector(scrollToBottom))
    let upBarButton = UIBarButtonItem(title: "↑", style: .plain, target: self, action: #selector(scrollToTop))
    let copyAllButton = UIBarButtonItem(title: "❐", style: .plain, target: self, action: #selector(copyAll))

    navigationItem.setLeftBarButtonItems([
      backBarButton, removeBarButton, mailBarButton
      ], animated: false)
    navigationItem.setRightBarButtonItems([
      refreshBarButton, downBarButton, upBarButton, copyAllButton
      ], animated: false)

    textView = UITextView()
    textView.isEditable = false
    view.addSubview(textView)

    activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicatorView.color = .black
    activityIndicatorView.startAnimating()
    activityIndicatorView.isHidden = true
    view.addSubview(activityIndicatorView)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    textView.frame = view.bounds
    activityIndicatorView.center = view.center
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    refreshLog()
  }

  // MARK: MFMailComposeViewControllerDelegate

  func mailComposeController(_ controller: MFMailComposeViewController,
                             didFinishWith result: MFMailComposeResult,
                             error: Error?) {
    if let error = error {
      showAlert(title: "Error", message: error.localizedDescription)
    }

    controller.dismiss(animated: true, completion: nil)
  }

  // MARK: Others

  @objc
  private func back() {
    navigationController?.popViewController(animated: true)
  }

  @objc
  private func remove() {
    ClientLogger.removeLogFile(file)
    reloadList()
    back()
  }

  @objc
  private func mail() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Selected part", style: .default, handler: { [unowned self] _ in
      var text: String?

      if let textRange = self.textView.selectedTextRange {
        text = self.textView.text(in: textRange)
      }

      self.tryToSendMail(text)
    }))

    alertController.addAction(UIAlertAction(title: "Whole log", style: .default, handler: { [unowned self] _ in
      self.tryToSendMail(self.textView.text)
    }))
    alertController.addAction(UIAlertAction(title: "Just file", style: .default, handler: { [unowned self] _ in
      self.tryToSendMail()
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alertController, animated: true, completion: nil)
  }

  @objc
  private func refresh() {
    refreshLog()
  }

  @objc
  private func scrollToBottom() {
    if !textView.text.isEmpty {
      let range = NSRange(location: textView.text.count, length: 0)
      textView.scrollRangeToVisible(range)
    }
  }

  @objc
  private func scrollToTop() {
    let range = NSRange(location: 0, length: 0)
    textView.scrollRangeToVisible(range)
  }

  @objc
  private func copyAll() {
    UIPasteboard.general.string = textView.text
  }

  private func refreshLog() {
    activityIndicatorView.isHidden = false

    ClientLogger.readLogFromFile(file, completion: { [weak self] log in
      guard let self = self else { return }

      self.textView.text = log

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        self.activityIndicatorView.isHidden = true
      })
    })
  }

  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
  }

  private func tryToSendMail(_ text: String? = nil) {
    if MFMailComposeViewController.canSendMail() {
      ClientLogger.logDataFromFile(file, completion: { [weak self] data in
        guard let self = self else { return }

        if let data = data {
          let vc = MFMailComposeViewController()
          vc.mailComposeDelegate = self

          if let text = text {
            vc.setMessageBody(text, isHTML: false)
          }

          vc.addAttachmentData(data, mimeType: "text/plain", fileName: "log")
          self.present(vc, animated: true, completion: nil)
        } else {
          self.showAlert(title: "Error", message: "There is no log data")
        }
      })
    } else {
      showAlert(title: "Warning", message: "Please configure your account in Mail.app")
    }
  }

}
