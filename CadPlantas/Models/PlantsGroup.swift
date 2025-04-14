//
//  PlantsGroup.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 12/04/25.
//

struct PlantsGroup: Identifiable, Codable {
    let id: String
    let subscriber: String
    let name: String
    let description: String?
    let createdAt: String
}
