//
//  CadPlantasApp.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 08/12/24.
//

import SwiftUI

@main
struct CadPlantasApp: App {
  @StateObject private var locationManager = LocationManager()
  
  var body: some Scene {
    WindowGroup {
      SplashScreenView()
        .environmentObject(locationManager)
        .onAppear {
          locationManager.requestLocation()
        }
    }
  }
}
