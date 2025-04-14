//
//  PlantService.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 12/04/25.
//

import Foundation
import SwiftUI

class PlantService {
  static func registerPlant(_ plant: PlantModel, token: String) async throws -> String {
    guard let url = URL(string: "\(AppEnvironment.baseURL)/api/v1/plants/register") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoder = JSONEncoder()
    let bodyData = try encoder.encode(plant)
    request.httpBody = bodyData
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let message = json["message"] as? String else {
      throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Resposta inesperada do servidor."])
    }
    
    return message
  }
  
  static func fetchPlantParts(token: String) async throws -> PlantPartsResponse {
    guard let url = URL(string: "\(AppEnvironment.baseURL)/api/v1/plants/parts") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(PlantPartsResponse.self, from: data)
  }
}
