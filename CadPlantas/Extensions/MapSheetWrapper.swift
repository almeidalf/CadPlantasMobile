//
//  MapSheetWrapper.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 12/04/25.
//

import CoreLocation
import SwiftUI

struct MapSheetWrapper: View {
  let location: CLLocationCoordinate2D
  @State private var showMap = false

  var body: some View {
    Group {
      if showMap {
        MapSheetView(latitude: location.latitude, longitude: location.longitude)
      } else {
        ProgressView("Carregando mapa...")
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              showMap = true
            }
          }
      }
    }
  }
}
