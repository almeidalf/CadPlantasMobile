//
//  MyList.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 07/04/25.
//

import MapKit
import SwiftUI

struct MyList: View {
  @AppStorage("token") private var token: String = ""
  @State private var plants: [PlantList] = []
  @State private var isLoading = false
  @State private var alertMessage = ""
  @State private var showAlert = false
  
  @State private var selectedLocation: CLLocationCoordinate2D?
  @State private var showMapSheet = false
  
  var body: some View {
    NavigationView {
      Group {
        if isLoading {
          ProgressView("Carregando plantas...")
        } else if plants.isEmpty {
          Text("Nenhuma planta cadastrada.")
            .foregroundColor(.gray)
        } else {
          List(plants) { plant in
            VStack(alignment: .leading, spacing: 8) {
              HStack(alignment: .top, spacing: 12) {
                if let imagePath = plant.images.first,
                   let url = URL(string: AppEnvironment.imageURL + "/" + imagePath) {
                  AsyncImage(url: url) { image in
                    image.resizable()
                  } placeholder: {
                    Color.gray.opacity(0.2)
                  }
                  .frame(width: 100, height: 100)
                  .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                  Text("Planta: \(plant.name)")
                    .font(.headline)
                  
                  Text("Família: \(plant.nameScientific)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                  
                  Text("Observações: \(plant.description)")
                    .font(.footnote)
                    .lineLimit(4)
                }
              }
              
              if !plant.morphologySummary.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                  ForEach(plant.morphologySummary, id: \.self) { item in
                    Text(item)
                      .font(.caption)
                      .foregroundColor(.gray)
                  }
                }
              }
              
              HStack(spacing: 8) {
                VStack(alignment: .leading) {
                  Text("📍LATITUDE: \(String(format: "%.5f", Double(plant.location.latitude) ?? 0.0))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                  
                  Text("📍LONGITUDE: \(String(format: "%.5f", Double(plant.location.longitude) ?? 0.0))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .onTapGesture {
                  selectedLocation = CLLocationCoordinate2D(
                    latitude: Double(plant.location.latitude) ?? 0.0,
                    longitude: Double(plant.location.longitude) ?? 0.0
                  )
                  showMapSheet = true
                }
                
                Spacer()
                
                VStack {
                  Text("Cadastrado em:")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                  
                  Text(plant.createdAt.formattedDate())
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
              }
              
              Text("👤 Cadastrado por: \(plant.registeredBy ?? "")")
                .font(.caption2)
                .foregroundColor(.secondary)
              
              HStack(spacing: 16) {
                Spacer()
                
                  Button {
                    onEdit(plant)
                  } label: {
                    Image(systemName: "pencil")
                  }

                  Button {
                    onShareQR(plant)
                  } label: {
                    Image(systemName: "qrcode")
                  }
                }
                .font(.body)
            }
            .padding(.vertical, 4)
          }
        }
      }
      .sheet(isPresented: $showMapSheet) {
        if let location = selectedLocation {
          MapSheetView(latitude: location.latitude, longitude: location.longitude)
        }
      }
      .navigationTitle("Minhas Plantas")
      .alert(isPresented: $showAlert) {
        Alert(title: Text("Erro"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
      .task {
        fetchPlants()
      }
    }
  }
  
  private func onEdit(_ plant: PlantList) {
    // Aqui você pode navegar para uma tela de edição
    print("Editar planta: \(plant.name)")
  }
  
  private func onShareQR(_ plant: PlantList) {
    // Aqui você pode abrir uma view com o QRCode da planta
    print("Compartilhar QR Code da planta: \(plant.id)")
  }
  
  func fetchPlants() {
    guard let url = URL(string: AppEnvironment.baseURL + "/api/v1/plants/list") else { return }
    
    isLoading = true
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { data, _, error in
      DispatchQueue.main.async {
        isLoading = false
        if let error = error {
          alertMessage = "Erro: \(error.localizedDescription)"
          showAlert = true
          return
        }
        
        guard let data = data else {
          alertMessage = "Resposta vazia do servidor."
          showAlert = true
          return
        }
        
        do {
          let decoded = try JSONDecoder().decode([PlantList].self, from: data)
          self.plants = decoded
        } catch {
          alertMessage = "Erro ao processar dados: \(error.localizedDescription)"
          showAlert = true
        }
      }
    }.resume()
  }
}

#Preview {
  MyList()
}
