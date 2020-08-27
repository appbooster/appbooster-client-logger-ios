//
//  Utility.swift
//  AppboosterClientLogger
//
//  Created by Appbooster on 27/03/2019.
//  Copyright © 2019 Appbooster. All rights reserved.
//

import Foundation

func clearUserDefaults() {
  if let domain = Bundle.main.bundleIdentifier {
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
  }
}

func clearKeychain() {
  let secItemClasses = [
    kSecClassGenericPassword,
    kSecClassInternetPassword,
    kSecClassCertificate,
    kSecClassKey,
    kSecClassIdentity
  ]

  for itemClass in secItemClasses {
    let spec: NSDictionary = [kSecClass: itemClass]
    SecItemDelete(spec)
  }
}

func clearCookies() {
  if let cookies = HTTPCookieStorage.shared.cookies {
    for cookie in cookies {
      HTTPCookieStorage.shared.deleteCookie(cookie)
    }
  }
}

func clearFiles() {
  for searchPath in [
    FileManager.SearchPathDirectory.documentDirectory,
    FileManager.SearchPathDirectory.libraryDirectory
    ] {
      if let searchPathUrl =  FileManager.default.urls(for: searchPath, in: .userDomainMask).first {
        do {
          let fileURLs = try FileManager.default.contentsOfDirectory(at: searchPathUrl,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: [])
          for fileURL in fileURLs {
            try FileManager.default.removeItem(at: fileURL)
          }
        } catch let error {
          print(error)
        }
      }
  }
}
