//
//  GroupServices.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 12/04/25.
//

import Foundation

@MainActor
class GroupService {
  static let shared = GroupService()
  
  func fetchGroups(token: String) async throws -> [PlantsGroup] {
    guard let url = URL(string: "\(AppEnvironment.baseURL)/api/v1/groups/list") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode([PlantsGroup].self, from: data)
  }
  
  func deleteGroup(id: String, token: String) async throws {
    guard let url = URL(string: "\(AppEnvironment.baseURL)/api/v1/groups/\(id)") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "DELETE"
    
    _ = try await URLSession.shared.data(for: request)
  }
  
  func createGroup(name: String, description: String, token: String) async throws {
    guard let url = URL(string: "\(AppEnvironment.baseURL)/api/v1/groups/create") else {
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"

    let body: [String: Any] = [
      "name": name,
      "description": description
    ]
    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    _ = try await URLSession.shared.data(for: request)
  }

  func updateGroup(id: String, name: String, description: String, token: String) async throws {
    guard let url = URL(string: "\(AppEnvironment.baseURL)/api/v1/groups/\(id)") else {
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PUT"

    let body: [String: Any] = [
      "name": name,
      "description": description
    ]
    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    _ = try await URLSession.shared.data(for: request)
  }
}
