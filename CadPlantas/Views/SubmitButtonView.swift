//
//  SubmitButtonView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 05/04/25.
//

import SwiftUI

struct SubmitButtonView: View {
  var isValid: Bool
  var onSubmit: () -> Void

  var body: some View {
    Button("Enviar", action: onSubmit)
      .padding()
      .frame(maxWidth: .infinity)
      .background(isValid ? Color.green : Color.gray)
      .foregroundColor(.white)
      .cornerRadius(8)
      .disabled(!isValid)
  }
}
