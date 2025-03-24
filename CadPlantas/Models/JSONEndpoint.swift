//
//  Endpoint.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 04/02/25.
//

import Foundation

public protocol Endpoint {
  var path: String { get }
  var method: HTTPMethod { get }
  var query: [URLQueryItem] { get }
}

public protocol JSONEndpoint: Endpoint {
  var body: [String: Any]? { get }
}

public protocol ArrayEndpoint: Endpoint {
  var body: [Any]? { get }
}

public enum HTTPMethod: String {
  case post
  case put
  case get
  case delete
}
