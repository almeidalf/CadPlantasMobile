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
  public var method: String = "POST"  // Usando POST para enviar dados
  public var query: [URLQueryItem] = []
  private let baseURL = "http://localhost:3000"
  
  // Inicializador
  public init(email: String, password: String) {
    self.path = "/api/v1/user/login"
    
    self.body = [:]
    
    body?["email"] = email
    body?["password"] = password
  }
  
  public func fullURL() -> URL? {
    return URL(string: baseURL + path)
  }
}

