//
//  SelectionListView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 04/04/25.
//

import SwiftUI

struct SelectionListView: View {
  let title: String
  let options: [String]
  let colors: [String]
  @Binding var selectedType: String
  @Binding var selectedColor: String
  let onSelectType: (String) -> Void
  let onSelectColor: (String) -> Void
  
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Tipo")) {
          ForEach(options, id: \.self) { option in
            Button(action: {
              selectedType = option
              onSelectType(option)
              
              // Fechar automaticamente se não tiver cores
              if colors.isEmpty {
                dismiss()
              }
            }) {
              HStack {
                Text(option)
                  .foregroundColor(option == selectedType ? .blue : .primary)
                Spacer()
                if option == selectedType {
                  Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                }
              }
            }
          }
        }

        if !colors.isEmpty {
          Section(header: Text("Cor")) {
            ForEach(colors, id: \.self) { color in
              Button(action: {
                selectedColor = color
                onSelectColor(color)
                dismiss()
              }) {
                HStack {
                  Text(color)
                    .foregroundColor(color == selectedColor ? .blue : .primary)
                  Spacer()
                  if color == selectedColor {
                    Image(systemName: "checkmark")
                      .foregroundColor(.blue)
                  }
                }
              }
            }
          }
        }
      }
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .listStyle(.insetGrouped)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark")
              .foregroundColor(.primary)
          }
        }
      }
    }
  }
}
