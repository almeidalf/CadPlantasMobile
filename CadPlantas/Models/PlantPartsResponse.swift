//
//  PlantPartsResponse.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 03/04/25.
//

struct PlantPartsResponse: Decodable {
  let leaf: [String]?
  let stem: [String]?
  let inflorescence: [String]?
  let fruit: [String]?
  let colors: [String]?
}
