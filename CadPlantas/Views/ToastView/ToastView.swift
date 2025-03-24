//
//  ToastView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 24/03/25.
//

import SwiftUI

struct ToastView: View {
  var message: String
  @Binding var isPresented: Bool
  
  var body: some View {
    if isPresented {
      Text(message)
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.red.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
  }
}
