import SwiftUI

struct PlantRegisterView: View {
  @AppStorage("token") private var token: String = ""
  @State private var showCameraPicker = false
  @State private var showPhotoLibraryPicker = false
  
  @State var name: String = ""
  @State var nameScientific: String = ""
  @State var description: String = ""
  @State var latitude: String = ""
  @State var longitude: String = ""
  
  @State private var selectedImages: [UIImage] = []
  @StateObject private var locationManager = LocationManager()
  @State private var showAlert = false
  @State private var alertMessage = ""
  @State private var imageToDelete: UIImage?
  @State private var showDeleteConfirmation = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 16) {
          TextField("Nome", text: $name)
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Color.black)
            .cornerRadius(8)
          
          TextField("Nome Científico", text: $nameScientific)
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Color.black)
            .cornerRadius(8)
          
          TextField("Descrição", text: $description)
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Color.black)
            .cornerRadius(8)
          
          // Campo de texto para latitude (somente leitura)
          TextField("Latitude", text: $latitude)
            .disabled(true)
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Color.black)
            .cornerRadius(8)
          
          TextField("Longitude", text: $longitude)
            .disabled(true)
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Color.black)
            .cornerRadius(8)
          
          HStack(spacing: 16) {
            Button(action: {
              showCameraPicker = true
            }) {
              Label("Tirar Foto", systemImage: "camera")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Button(action: {
              showPhotoLibraryPicker = true
            }) {
              Label("Galeria", systemImage: "photo")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
          }
          
          if !selectedImages.isEmpty {
            ScrollView(.horizontal) {
              HStack {
                ForEach(selectedImages, id: \.self) { image in
                  ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                      .resizable()
                      .scaledToFill()
                      .frame(width: 100, height: 100)
                      .clipped()
                      .cornerRadius(8)
                      .onTapGesture {
                        imageToDelete = image
                        showDeleteConfirmation = true
                      }
                    
                    Button(action: {
                      imageToDelete = image
                      showDeleteConfirmation = true
                    }) {
                      Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                    }
                    .padding(5)
                  }
                }
              }
            }
          }
          
          Button("Enviar") {
            submitForm()
          }
          .padding()
          .frame(maxWidth: .infinity)
          .background(isValid ? Color.green : Color.gray)
          .foregroundColor(.white)
          .cornerRadius(8)
          .disabled(!isValid)
        }
        .padding(.all, 16)
        .onAppear {
          locationManager.requestLocation()
        }
        .onChange(of: locationManager.location) { newLocation in
          if let location = newLocation {
            self.latitude = String(location.coordinate.latitude)
            self.longitude = String(location.coordinate.longitude)
          }
        }
        .alert(isPresented: $showAlert) {
          Alert(title: Text("Atenção"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showCameraPicker) {
          CameraPicker(selectedImages: $selectedImages)
        }
        .sheet(isPresented: $showPhotoLibraryPicker) {
          PhotoLibraryPicker(
            selectedImages: $selectedImages,
            latitude: $latitude,
            longitude: $longitude
          )
        }
        .confirmationDialog("Deseja remover esta imagem?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
          Button("Remover", role: .destructive) {
            if let image = imageToDelete, let index = selectedImages.firstIndex(of: image) {
              selectedImages.remove(at: index)
            }
            imageToDelete = nil
          }
          Button("Cancelar", role: .cancel) {
            imageToDelete = nil
          }
        }
      }
      .navigationTitle("Cadastro de Planta")
    }
  }
  
  var isValid: Bool {
    !name.isEmpty && !description.isEmpty && !selectedImages.isEmpty
  }
  
  func submitForm() {
    if isValid {
      
      let plant = PlantModel(
        name: name,
        nameScientific: nameScientific,
        description: description,
        location: Location(latitude: latitude, longitude: longitude),
        images: selectedImages
      )
      
      let endpoint = PlantEndpoint(plant: plant)
      
      sendRequest(endpoint: endpoint, token: token)
    } else {
      alertMessage = "Preencha todos os campos e adicione pelo menos uma imagem!"
    }
    showAlert = true
  }
  
  func sendRequest(endpoint: PlantEndpoint, token: String) {
    guard let url = endpoint.fullURL() else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method
    
    // Adicionando o Bearer token no cabeçalho da requisição
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      if let body = endpoint.body {
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
      }
    } catch {
      print("Erro ao codificar os dados: \(error.localizedDescription)")
      return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Erro de requisição: \(error.localizedDescription)")
        return
      }
      
      if let data = data {
        if let responseString = String(data: data, encoding: .utf8) {
          print("Resposta do servidor: \(responseString)")
        }
      }
    }
    
    task.resume()
  }
}

#Preview {
  PlantRegisterView()
}
