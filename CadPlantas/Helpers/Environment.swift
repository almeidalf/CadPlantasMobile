//
//  Environment.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 24/03/25.
//

import Foundation

enum AppEnvironment {
  static var baseURL: String {
    return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
  }
}
