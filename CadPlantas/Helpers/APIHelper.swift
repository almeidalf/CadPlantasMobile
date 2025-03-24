//
//  APIHelper.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 04/02/25.
//

import Foundation

// Definindo o erro que pode ocorrer ao fazer a requisição
enum NetworkError: Error {
  case badURL
  case requestFailed
  case decodingError
  case invalidStatusCode(Int)
}

// Helper para realizar as requisições
class APIHelper {
  
  static let shared = APIHelper()
  
  private init() {}
  
  // Função genérica para realizar requisições GET
  func fetchData<T: Decodable>(from endpoint: String, token: String, completion: @escaping (Result<(T, Int), NetworkError>) -> Void) {
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.badURL))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET" // Pode ser alterado para POST, PUT, DELETE conforme necessário
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Adicionando o Bearer token
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Erro de requisição: \(error.localizedDescription)")
        completion(.failure(.requestFailed))
        return
      }
      
      guard let data = data else {
        completion(.failure(.requestFailed))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(.requestFailed))
        return
      }
      
      let statusCode = httpResponse.statusCode
      if statusCode >= 200 && statusCode < 500 {
        do {
          let decoder = JSONDecoder()
          let result = try decoder.decode(T.self, from: data)
          completion(.success((result, statusCode))) // Retornando dados e statusCode
        } catch {
          print("Erro ao decodificar dados: \(error.localizedDescription)")
          completion(.failure(.decodingError))
        }
      } else {
        completion(.failure(.invalidStatusCode(statusCode))) // Retornando erro com status code inválido
      }
    }
    
    task.resume()
  }
  
  func postData<T: Decodable, U: Encodable>(to endpoint: String, token: String, body: U, completion: @escaping (Result<(T, Int), NetworkError>) -> Void) {
    guard let url = URL(string: endpoint) else {
      completion(.failure(.badURL))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      // Codificando o corpo da requisição
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(body)  // O corpo é um modelo `PlantModel`
      request.httpBody = jsonData
    } catch {
      print("Erro ao codificar dados: \(error.localizedDescription)")
      completion(.failure(.requestFailed))
      return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Erro de requisição: \(error.localizedDescription)")
        completion(.failure(.requestFailed))
        return
      }
      
      guard let data = data else {
        completion(.failure(.requestFailed))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(.requestFailed))
        return
      }
      
      let statusCode = httpResponse.statusCode
      if statusCode >= 200 && statusCode < 500 {
        do {
          let decoder = JSONDecoder()
          let result = try decoder.decode(T.self, from: data)
          completion(.success((result, statusCode)))
        } catch {
          print("Erro ao decodificar dados: \(error.localizedDescription)")
          completion(.failure(.decodingError))
        }
      } else {
        completion(.failure(.invalidStatusCode(statusCode)))
      }
    }
    
    task.resume()
  }
}
  
