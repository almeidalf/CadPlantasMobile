//
//  TreeRegisterView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 24/03/25.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct TreeRegisterView: View {
//  // MARK: - Variables
//  
//  @AppStorage("token") private var token: String = ""
//  
//  @State var name: String = ""
//  @State var nameScientific: String = ""
//  @State var description: String = ""
//  @State var latitude: String = ""
//  @State var longitude: String = ""
//  
//  @State private var selectedImages: [UIImage] = []
//  @State private var showCameraPicker = false
//  @State private var showPhotoLibraryPicker = false
//  @StateObject private var locationManager = LocationManager()
//  @State private var showAlert = false
//  @State private var alertMessage = ""
//  @State private var imageToDelete: UIImage?
//  @State private var showDeleteConfirmation = false
//  @State private var imageFromCamera = false
//  @State private var cameraPickerJustClosed = false
//  
//  var isValid: Bool {
//    !name.isEmpty && !description.isEmpty && !selectedImages.isEmpty
//  }
//  
//  // MARK: - Body
//  
  var body: some View {
    Text("A")
  }
//    NavigationView {
//      ScrollView {
//        VStack(spacing: 16) {
//          TextField("Nome", text: $name)
//            .padding()
//            .background(Color.buttonBackground)
//            .foregroundColor(Color.primaryText)
//            .cornerRadius(8)
//          
//          TextField("Nome Científico", text: $nameScientific)
//            .padding()
//            .background(Color.buttonBackground)
//            .foregroundColor(Color.primaryText)
//            .cornerRadius(8)
//          
//          TextField("Descrição", text: $description)
//            .padding()
//            .background(Color.buttonBackground)
//            .foregroundColor(Color.primaryText)
//            .cornerRadius(8)
//          
//          if let lat = Double(latitude), let lon = Double(longitude) {
//            HStack(alignment: .center) {
//              Text("Latitude: \(String(format: "%.6f", lat))")
//                .padding()
//                .background(Color.buttonBackground.opacity(0.4))
//                .foregroundColor(Color.primaryText.opacity(0.4))
//                .cornerRadius(8)
//              
//              Text("Longitude: \(String(format: "%.6f", lon))")
//                .padding()
//                .background(Color.buttonBackground.opacity(0.4))
//                .foregroundColor(Color.primaryText.opacity(0.4))
//                .cornerRadius(8)
//            }
//          }
//          
//          HStack(spacing: 16) {
//            Button(action: {
//              showCameraPicker = true
//              imageFromCamera = true
//            }) {
//              Label("Tirar Foto", systemImage: "camera")
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//
//            Button(action: {
//              showPhotoLibraryPicker = true
//              imageFromCamera = false
//            }) {
//              Label("Galeria", systemImage: "photo")
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.indigo)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//          }
//          
//          if !selectedImages.isEmpty {
//            ScrollView(.horizontal) {
//              HStack {
//                ForEach(selectedImages, id: \.self) { image in
//                  ZStack(alignment: .topTrailing) {
//                    Image(uiImage: image)
//                      .resizable()
//                      .scaledToFill()
//                      .frame(width: 200, height: 200)
//                      .clipped()
//                      .cornerRadius(8)
//                      .onTapGesture {
//                        imageToDelete = image
//                        showDeleteConfirmation = true
//                      }
//
//                    Button(action: {
//                      imageToDelete = image
//                      showDeleteConfirmation = true
//                    }) {
//                      Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.white)
//                        .background(Color.black.opacity(0.6))
//                        .clipShape(Circle())
//                    }
//                    .padding(5)
//                  }
//                }
//              }
//            }
//          }
//          
//          // Botão de Enviar
//          Button("Enviar") {
//            submitForm()
//          }
//          .padding()
//          .frame(maxWidth: .infinity)
//          .background(isValid ? Color.green : Color.gray)
//          .foregroundColor(.white)
//          .cornerRadius(8)
//          .disabled(!isValid)
//        }
//        .padding(.all, 16)
//        .onChange(of: selectedImages) { newImages in
//          if !newImages.isEmpty, latitude == "0", longitude == "0" {
//            locationManager.requestLocation()
//          }
//          
//          if newImages.isEmpty {
//            latitude = ""
//            longitude = ""
//          }
//        }
//        .onChange(of: locationManager.location) { newLocation in
//          if imageFromCamera, let location = newLocation {
//            latitude = String(location.coordinate.latitude)
//            longitude = String(location.coordinate.longitude)
//          }
//        }
//        .sheet(isPresented: $showCameraPicker) {
//          CameraPicker(selectedImages: $selectedImages)
//        }
//        .onDisappear {
//          if imageFromCamera {
//            cameraPickerJustClosed = true
//          }
//        }
//        .sheet(isPresented: $showPhotoLibraryPicker) {
//          PhotoLibraryPicker(
//            selectedImages: $selectedImages,
//            latitude: $latitude,
//            longitude: $longitude
//          )
//        }
//        .alert(isPresented: $showAlert) {
//          Alert(title: Text("Atenção"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//        .confirmationDialog("Deseja remover esta imagem?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
//          Button("Remover", role: .destructive) {
//            if let image = imageToDelete, let index = selectedImages.firstIndex(of: image) {
//              selectedImages.remove(at: index)
//            }
//            imageToDelete = nil
//          }
//          Button("Cancelar", role: .cancel) {
//            imageToDelete = nil
//          }
//        }
//      }
//      .navigationTitle("Cadastro de Árvore")
//    }
//  }
//  
//  // MARK: - Internal Methods
//  
//  func submitForm() {
//    if isValid {
//      
//      let plant = PlantModel(
//        name: name,
//        nameScientific: nameScientific,
//        description: description,
//        location: Location(latitude: latitude, longitude: longitude),
//        images: selectedImages
//      )
//      
//      let endpoint = PlantEndpoint(plant: plant)
//      
//      sendRequest(endpoint: endpoint, token: token)
//    } else {
//      alertMessage = "Preencha todos os campos e adicione pelo menos uma imagem!"
//    }
//    showAlert = true
//  }
//  
//  func sendRequest(endpoint: PlantEndpoint, token: String) {
//    guard let url = endpoint.fullURL() else { return }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = endpoint.method
//    
//    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    do {
//      if let body = endpoint.body {
//        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
//        request.httpBody = jsonData
//      }
//    } catch {
//      print("Erro ao codificar os dados: \(error.localizedDescription)")
//      return
//    }
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//      if let error = error {
//        print("Erro de requisição: \(error.localizedDescription)")
//        return
//      }
//      
//      if let data = data {
//        if let responseString = String(data: data, encoding: .utf8) {
//          print("Resposta do servidor: \(responseString)")
//        }
//      }
//    }
//    
//    task.resume()
//  }
}

#Preview {
  TreeRegisterView()
}

