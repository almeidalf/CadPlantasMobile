//
//  GetPlantsPartEndpoint.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 03/04/25.
//

import Foundation

public struct GetPlantsPartEndpoint {
  public var path: String
  public var body: [String: Any]?
  public var method: String = "GET"
  public var query: [URLQueryItem] = []
  
  // Inicializador
  public init(plant: PlantModel) {
    self.path = "/api/v1/plants/parts"
  }
  
  public func fullURL() -> URL? {
    URL(string: AppEnvironment.baseURL + path)
  }
}
