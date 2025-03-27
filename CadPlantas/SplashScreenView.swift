//
//  SplashScreenView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 26/03/25.
//

import SwiftUI

struct SplashScreenView: View {
  @State private var isActive = false

  var body: some View {
    if isActive {
      LoginView()
    } else {
      VStack {
        Image("AppIconSplash")
          .resizable()
          .scaledToFill()
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation {
            isActive = true
          }
        }
      }
    }
  }
}
