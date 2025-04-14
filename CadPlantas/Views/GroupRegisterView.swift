//
//  GroupRegisterView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 12/04/25.
//

import SwiftUI

struct GroupRegisterView: View {
  var groupToEdit: PlantsGroup? = nil
  var onSuccess: () -> Void

  @AppStorage("token") private var token: String = ""
  @Environment(\.dismiss) private var dismiss

  @State private var name: String = ""
  @State private var description: String = ""
  @State private var isSaving = false
  @State private var errorMessage: String?

  var body: some View {
    NavigationStack {
      VStack {
        Form {
          Section(header: Text("Informações do Grupo")) {
            TextField("Nome", text: $name)
              .autocapitalization(.words)
            TextField("Descrição", text: $description)
          }
          
          if let errorMessage {
            Text(errorMessage)
              .foregroundColor(.red)
          }
        }
        
        Button(action: {
          Task { await saveGroup() }
        }) {
          if isSaving {
            ProgressView()
          } else {
            Text(groupToEdit == nil ? "Criar Grupo" : "Salvar Alterações")
              .bold()
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
        }
        .padding()
        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
      }
      .navigationTitle(groupToEdit == nil ? "Novo Grupo" : "Editar Grupo")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") {
            dismiss()
          }
        }
      }
      .onAppear {
        if let group = groupToEdit {
          name = group.name
          description = group.description ?? ""
        }
      }
    }
  }

  private func saveGroup() async {
    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
      errorMessage = "O nome do grupo é obrigatório."
      return
    }

    isSaving = true
    errorMessage = nil

    do {
      if let group = groupToEdit {
        try await GroupService.shared.updateGroup(
          id: group.id,
          name: name,
          description: description,
          token: token
        )
      } else {
        try await GroupService.shared.createGroup(
          name: name,
          description: description,
          token: token
        )
      }

      onSuccess()
      dismiss()
    } catch {
      errorMessage = "Erro ao salvar grupo: \(error.localizedDescription)"
    }

    isSaving = false
  }
}
