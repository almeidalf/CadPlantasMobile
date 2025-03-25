//
//  LoginEndpoint.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 24/03/25.
//

import Foundation

public struct LoginEndpoint {
  public var path: String
  public var body: [String: Any]?
  public var method: String = "POST"
  public var query: [URLQueryItem] = []
  
  public init(email: String, password: String) {
    self.path = "/api/v1/user/login"
    
    self.body = [:]
    body?["email"] = email
    body?["password"] = password
  }
  
  public func fullURL() -> URL? {
    URL(string: Environment.baseURL + path)
  }
}

