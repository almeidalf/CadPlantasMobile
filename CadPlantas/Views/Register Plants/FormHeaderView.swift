//
//  FormHeaderView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 05/04/25.
//

import SwiftUI

struct FormHeaderView: View {
  @Binding var name: String
  @Binding var nameScientific: String
  @Binding var description: String

  var body: some View {
    VStack(spacing: 16) {
      TextField("Nome", text: $name)
        .padding()
        .background(Color.buttonBackground)
        .foregroundColor(Color.primaryText)
        .cornerRadius(8)

      TextField("Familia", text: $nameScientific)
        .padding()
        .background(Color.buttonBackground)
        .foregroundColor(Color.primaryText)
        .cornerRadius(8)

      TextField("Observações", text: $description)
        .padding()
        .background(Color.buttonBackground)
        .foregroundColor(Color.primaryText)
        .cornerRadius(8)
    }
  }
}
