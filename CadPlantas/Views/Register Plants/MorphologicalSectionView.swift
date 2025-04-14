//
//  MorphologicalSectionView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 05/04/25.
//

import SwiftUI

struct MorphologicalSectionView: View {
  let leaf: [String]
  let stem: [String]
  let inflorescence: [String]
  let fruit: [String]
  let colors: [String]

  @Binding var leafSelected: String
  @Binding var leafColorSelected: String
  @Binding var stemSelected: String
  @Binding var inflorescenceSelected: String
  @Binding var inflorescenceColorSelected: String
  @Binding var fruitSelected: String
  @Binding var fruitColorSelected: String
  @Binding var sheetData: FieldSheetData?

  var body: some View {
    Section(header: Text("Características Morfológicas")) {
      SelectableField(
        title: "Folha",
        value: $leafSelected,
        color: leafColorSelected
      ) {
        if !leaf.isEmpty {
          sheetData = FieldSheetData(field: .leaf, options: leaf, showColorPicker: true)
        }
      }

      SelectableField(
        title: "Caule",
        value: $stemSelected
      ) {
        if !stem.isEmpty {
          sheetData = FieldSheetData(field: .stem, options: stem, showColorPicker: false)
        }
      }

      SelectableField(
        title: "Inflorescência",
        value: $inflorescenceSelected,
        color: inflorescenceColorSelected
      ) {
        if !inflorescence.isEmpty {
          sheetData = FieldSheetData(field: .inflorescence, options: inflorescence, showColorPicker: true)
        }
      }

      SelectableField(
        title: "Fruto",
        value: $fruitSelected,
        color: fruitColorSelected
      ) {
        if !fruit.isEmpty {
          sheetData = FieldSheetData(field: .fruit, options: fruit, showColorPicker: true)
        }
      }
    }
  }
}
