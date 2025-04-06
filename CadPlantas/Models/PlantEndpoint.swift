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
    
    if let leaf = plant.leaf {
      body?["leaf"] = leaf
    }
    
    if let leafColor = plant.leafColor {
      body?["leafColor"] = leafColor
    }
    
    if let stem = plant.stem {
      body?["stem"] = stem
    }
    
    if let inflorescence = plant.inflorescence {
      body?["inflorescence"] = inflorescence
    }
    
    if let inflorescenceColor = plant.inflorescenceColor {
      body?["inflorescenceColor"] = inflorescenceColor
    }
    
    if let fruit = plant.fruit {
      body?["fruit"] = fruit
    }
    
    if let fruitColor = plant.fruitColor {
      body?["fruitColor"] = fruitColor
    }
    
    body?["images"] = plant.images
    
    body?["isPublic"] = plant.isPublic
  }
  
  public func fullURL() -> URL? {
    URL(string: AppEnvironment.baseURL + path)
  }
}
