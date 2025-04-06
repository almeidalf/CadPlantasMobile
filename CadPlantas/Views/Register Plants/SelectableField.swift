//
//  SelectableField.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 04/04/25.
//

import SwiftUI

struct SelectableField: View {
  let title: String
  @Binding var value: String
  var color: String? = nil
  let action: () -> Void

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(displayText)
        .foregroundColor(value.isEmpty ? .gray : .primary)
    }
    .contentShape(Rectangle())
    .onTapGesture(perform: action)
  }

  private var displayText: String {
    if value.isEmpty {
      return "Selecionar..."
    }
    if let color, !color.isEmpty {
      return "\(value) – \(color)"
    }
    return value
  }
}
