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
  public let images: [String]?
  
  public init(name: String? = nil, nameScientific: String? = nil, description: String? = nil, location: Location? = nil, images: [UIImage]? = nil) {
    self.name = name
    self.nameScientific = nameScientific
    self.description = description
    self.location = location
    
    self.images = images?.compactMap { image in
      let resized = image.resized(toMaxWidth: 1280)
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
