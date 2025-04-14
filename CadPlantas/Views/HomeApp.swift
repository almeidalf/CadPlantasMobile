//
//  HomeView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 08/12/24.
//

import SwiftUI

struct HomeView: View {
  @AppStorage("token") private var token: String = ""
  @State private var groups: [PlantsGroup] = []
  @State private var isLoading = true
  @State private var showingGroupRegister = false
  @State private var selectedGroup: PlantsGroup? = nil
  @State private var errorMessage: String?
  @State private var isRefreshing = false
  @State private var isCreatingGroup = false

  var body: some View {
    VStack {
      if isLoading {
        Spacer()
        ProgressView("Carregando grupos...")
        Spacer()
      } else if let errorMessage = errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
          .multilineTextAlignment(.center)
          .padding()
      } else if groups.isEmpty {
        VStack(spacing: 16) {
          Text("Nenhum grupo encontrado.")
            .foregroundColor(.gray)

          Button {
            isCreatingGroup = true
          } label: {
            Label("Criar Grupo", systemImage: "plus")
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.blue.opacity(0.1))
              .cornerRadius(10)
          }
        }
        .frame(maxHeight: .infinity)
        .padding()
      } else {
        ScrollView {
          LazyVStack(spacing: 16) {
            ForEach(groups) { group in
              VStack(alignment: .leading, spacing: 12) {
                Text(group.name)
                  .font(.title3)
                  .bold()

                if let desc = group.description, !desc.isEmpty {
                  Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }

                HStack(spacing: 16) {
                  Button {
                    selectedGroup = group
                    showingGroupRegister = true
                  } label: {
                    Label("Editar", systemImage: "pencil")
                  }

                  Button {
                    Task {
                      try? await GroupService.shared.deleteGroup(id: group.id, token: token)
                      await loadGroups()
                    }
                  } label: {
                    Label("Excluir", systemImage: "trash")
                  }
                  .foregroundColor(.red)

                  Spacer()

                  NavigationLink(destination: PlantRegisterView(groupId: group.id)) {
                    Label("Plantas", systemImage: "arrow.right.circle.fill")
                  }
                }
                .font(.subheadline)
              }
              .padding()
              .background(Color(.systemGray6))
              .cornerRadius(12)
              .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
              .padding(.horizontal)
            }
          }
          .padding(.top)
        }
        .refreshable {
          await loadGroups(isManualRefresh: true)
        }
      }
    }
    .navigationTitle("Meus Grupos")
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          token = ""
        } label: {
          Image(systemName: "door.right.hand.open")
            .foregroundColor(.red)
        }
      }

      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          isCreatingGroup = true
        } label: {
          Image(systemName: "plus")
        }
      }
    }
    .sheet(item: $selectedGroup) { group in
      GroupRegisterView(groupToEdit: group, onSuccess: {
        Task { await loadGroups() }
        selectedGroup = nil
      })
    }
    .sheet(isPresented: $isCreatingGroup) {
      GroupRegisterView(groupToEdit: nil, onSuccess: {
        Task { await loadGroups() }
        isCreatingGroup = false
      })
    }
    .task {
      await loadGroups()
    }
  }

  func loadGroups(isManualRefresh: Bool = false) async {
    if isManualRefresh {
      isRefreshing = true
    } else {
      isLoading = true
    }

    errorMessage = nil

    do {
      groups = try await GroupService.shared.fetchGroups(token: token)
    } catch {
      errorMessage = "Erro ao carregar grupos: \(error.localizedDescription)"
    }

    isLoading = false
    isRefreshing = false
  }
}

#Preview {
  HomeView()
}
