//
//  LocationDisplayView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 05/04/25.
//

import SwiftUI

struct LocationDisplayView: View {
  let latitude: String
  let longitude: String

  var body: some View {
    if let lat = Double(latitude), let lon = Double(longitude) {
      HStack(spacing: 8) {
        Text("Latitude: \(String(format: "%.5f", lat))")
        Text("Longitude: \(String(format: "%.5f", lon))")
      }
      .padding()
      .background(Color.buttonBackground.opacity(0.4))
      .foregroundColor(Color.primaryText.opacity(0.4))
      .cornerRadius(8)
    }
  }
}
