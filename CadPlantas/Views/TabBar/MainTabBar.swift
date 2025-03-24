//
//  MainTabBar.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 24/03/25.
//

import SwiftUI

struct MainTabBar: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      ProfileView()
        .tabItem {
          Label("Perfil", systemImage: "person.fill")
        }
    }
    .navigationBarBackButtonHidden(true)
  }
}
