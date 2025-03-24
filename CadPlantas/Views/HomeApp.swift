//
//  HomeView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 08/12/24.
//

import SwiftUI

struct HomeView: View {
  @AppStorage("token") private var token: String = ""

  var body: some View {
    VStack(spacing: 32) {
      HStack {
        Spacer()
        Button(action: {
          token = ""
        }) {
          Image(systemName: "door.right.hand.open")
            .font(.title)
            .foregroundColor(.red)
            .padding()
        }
      }

      Text("Cadastre sua contribuição")
        .font(.title2)
        .bold()

      HStack(spacing: 20) {
        NavigationLink(destination: PlantRegisterView()) {
          VStack {
            Image(systemName: "leaf.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 60, height: 60)
              .foregroundColor(.green)
            Text("Planta")
              .foregroundColor(.primary)
              .font(.headline)
          }
          .frame(width: 120, height: 120)
          .background(Color.gray.opacity(0.2))
          .cornerRadius(12)
        }

        NavigationLink(destination: TreeRegisterView()) {
          VStack {
            Image(systemName: "tree.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 60, height: 60)
              .foregroundColor(.brown)
            
            Text("Árvore")
              .foregroundColor(.primary)
              .font(.headline)
          }
          .frame(width: 120, height: 120)
          .background(Color.gray.opacity(0.2))
          .cornerRadius(12)
        }
      }

      Spacer()
    }
    .padding()
    .navigationBarBackButtonHidden(true)
  }
}

#Preview {
  HomeView()
}
