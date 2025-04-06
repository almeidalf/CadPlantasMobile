//
//  Morphologic.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 05/04/25.
//

import SwiftUI

struct MorphologicalFieldSelector: View {
  let title: String
  let options: [String]
  let colors: [String]
  @Binding var selectedValue: String
  @Binding var selectedColor: String
  let onTap: () -> Void

  var body: some View {
    VStack(spacing: 8) {
      SelectableField(title: title, value: $selectedValue, action: onTap)

      if !selectedValue.isEmpty {
        Picker("Cor", selection: $selectedColor) {
          ForEach(colors, id: \.self) { color in
            Text(color).tag(color)
          }
        }
        .pickerStyle(.menu)
      }
    }
  }
}
