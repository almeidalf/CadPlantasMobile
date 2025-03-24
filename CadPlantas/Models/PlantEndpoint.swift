//
//  PlantEndpoint.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 04/02/25.
//

import Foundation

public struct PlantEndpoint {
  public var path: String
  public var body: [String: Any]?
  public var method: String = "POST"  // Usando POST para enviar dados
  public var query: [URLQueryItem] = []
  private let baseURL = "http://localhost:3000"
  
  // Inicializador
  public init(plant: PlantModel) {
    self.path = "/api/v1/plants/register" // Path da API
    
    // Montando o corpo da requisição (body)
    self.body = [:]
    
    // Adicionando os campos simples ao corpo do JSON
    if let name = plant.name {
      body?["name"] = name
    }
    
    if let nameScientific = plant.nameScientific {
      body?["nameScientific"] = nameScientific
    }
    
    if let description = plant.description {
      body?["description"] = description
    }
    
    if let location = plant.location {
      body?["location"] = [
        "latitude": location.latitude,
        "longitude": location.longitude
      ]
    }
    
    body?["images"] = plant.images
  }
  
  public func fullURL() -> URL? {
    return URL(string: baseURL + path)
  }
}
