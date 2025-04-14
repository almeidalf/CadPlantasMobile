//
//  String.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 09/04/25.
//

import Foundation

extension String {
  func formattedDate() -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
    
    if let date = isoFormatter.date(from: self) {
      return formatter.string(from: date)
    }
    
    return self
  }
}
