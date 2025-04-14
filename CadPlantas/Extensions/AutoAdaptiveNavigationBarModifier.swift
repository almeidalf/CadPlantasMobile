//
//  AutoAdaptiveNavigationBarModifier.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 12/04/25.
//

import SwiftUI

struct AutoAdaptiveNavigationBarModifier: ViewModifier {
  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    
    // Aqui deixamos que o sistema escolha a cor com base no modo (light/dark)
    appearance.backgroundColor = UIColor.systemBackground
    appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }

  func body(content: Content) -> some View {
    content
  }
}

extension View {
  func adaptiveNavigationBar() -> some View {
    self.modifier(AutoAdaptiveNavigationBarModifier())
  }
}
