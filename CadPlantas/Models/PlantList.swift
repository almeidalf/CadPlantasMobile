//
//  PlantList.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 09/04/25.
//

struct PlantList: Identifiable, Codable {
  let id: String
  let name: String
  let nameScientific: String
  let description: String
  let images: [String]
  let location: LocationData
  let createdAt: String
  let isPublic: Bool
  let leaf: String?
  let leafColor: String?
  let stem: String?
  let inflorescence: String?
  let inflorescenceColor: String?
  let fruit: String?
  let fruitColor: String?
  let registeredBy: String?
  
  struct LocationData: Codable {
    let latitude: String
    let longitude: String
  }
}

extension PlantList {
  var morphologySummary: [String] {
    var items: [String] = []
    
    if let leaf = leaf { items.append("🌿 Folha: \(leaf)") }
    if let leafColor = leafColor { items.append("Cor da folha: \(leafColor)") }
    if let stem = stem { items.append("🌴 Caule: \(stem)") }
    if let inflorescence = inflorescence { items.append("🌻 Inflorescência: \(inflorescence)") }
    if let inflorescenceColor = inflorescenceColor { items.append("Cor da inflorescência: \(inflorescenceColor)") }
    if let fruit = fruit { items.append("🍍 Fruto: \(fruit)") }
    if let fruitColor = fruitColor { items.append("Cor do fruto: \(fruitColor)") }
    
    return items
  }
}

