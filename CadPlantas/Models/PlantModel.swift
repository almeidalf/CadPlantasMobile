//
//  PlantModel.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 04/02/25.
//

import Foundation
import UIKit

public struct PlantModel: Encodable {
  public let name: String?
  public let nameScientific: String?
  public let description: String?
  public let location: Location?
  public let leaf: String?
  public let leafColor: String?
  public let stem: String?
  public let inflorescence: String?
  public let inflorescenceColor: String?
  public let fruit: String?
  public let fruitColor: String?
  public let images: [String]?
  public let isPublic: Bool?
  
  public init(
    name: String? = nil,
    nameScientific: String? = nil,
    description: String? = nil,
    location: Location? = nil,
    leaf: String? = nil,
    leafColor: String? = nil,
    stem: String? = nil,
    inflorescence: String? = nil,
    inflorescenceColor: String? = nil,
    fruit: String? = nil,
    fruitColor: String? = nil,
    images: [IdentifiableImage]? = nil,
    isPublic: Bool = true
  ) {
    self.name = name
    self.nameScientific = nameScientific
    self.description = description
    self.location = location
    self.leaf = leaf
    self.leafColor = leafColor
    self.stem = stem
    self.inflorescence = inflorescence
    self.inflorescenceColor = inflorescenceColor
    self.fruit = fruit
    self.fruitColor = fruitColor
    self.isPublic = isPublic
    
    self.images = images?.compactMap { identifiable in
      let resized = identifiable.image.resized(toMaxWidth: 1280)
      return resized.jpegData(compressionQuality: 0.8)?.base64EncodedString()
    }
  }
}

// Modelo para a localização
public struct Location: Encodable {
  public let latitude: String?
  public let longitude: String?
}

extension UIImage {
  func resized(toMaxWidth maxWidth: CGFloat) -> UIImage {
    let aspectRatio = size.height / size.width
    let newSize = CGSize(width: maxWidth, height: maxWidth * aspectRatio)
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }
}

