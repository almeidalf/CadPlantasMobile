//
//  SubmitButtonView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 05/04/25.
//

import SwiftUI

struct SubmitButtonView: View {
  var isValid: Bool
  var isLoading: Bool
  var onSubmit: () -> Void

  var body: some View {
    Button(action: {
      if !isLoading {
        onSubmit()
      }
    }) {
      HStack {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
        } else {
          Text("Enviar")
            .bold()
        }
      }
      .frame(maxWidth: .infinity)
      .padding()
      .background(isValid ? Color.blue : Color.gray)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .disabled(!isValid || isLoading)
  }
}
