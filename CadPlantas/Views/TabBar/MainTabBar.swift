//
//  MainTabBar.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 24/03/25.
//

import SwiftUI

struct MainTabBar: View {
  var body: some View {
    NavigationStack {
      TabView {
        HomeView()
          .tabItem {
            Label("Home", systemImage: "house.fill")
          }

        MyList()
          .tabItem {
            Label("Minha Lista", systemImage: "doc.text.magnifyingglass")
          }

        ProfileView()
          .tabItem {
            Label("Perfil", systemImage: "person.fill")
          }
      }
    }
  }
}
