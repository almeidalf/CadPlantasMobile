import SwiftUI
import PhotosUI
import CoreLocation

struct PlantRegisterView: View {
  @AppStorage("token") private var token: String = ""
  
  @State var name: String = ""
  @State var nameScientific: String = ""
  @State var description: String = ""
  @State var latitude: String = ""
  @State var longitude: String = ""
  
  @State private var selectedImages: [UIImage] = []
  @State private var showImagePicker = false
  @StateObject private var locationManager = LocationManager()
  @State private var showAlert = false
  @State private var alertMessage = ""
  
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
          
          // Campo de texto para longitude (somente leitura)
          TextField("Longitude", text: $longitude)
            .disabled(true)
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Color.black)
            .cornerRadius(8)
          
          // Botão para selecionar imagens
          Button(action: {
            showImagePicker.toggle()
          }) {
            Text("Selecionar Imagens")
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
          .padding(.bottom, 16)
          
          // Exibição das imagens selecionadas
          if !selectedImages.isEmpty {
            ScrollView(.horizontal) {
              HStack {
                ForEach(selectedImages, id: \.self) { image in
                  Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
                }
              }
            }
          }
          
          // Botão de Enviar
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
        .sheet(isPresented: $showImagePicker) {
          ImagePicker(selectedImages: $selectedImages)
        }
        .alert(isPresented: $showAlert) {
          Alert(title: Text("Atenção"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
      }
      .navigationTitle("Cadastro de Planta")
    }
  }
  
  //Propriedade computada para validar se o formulário pode ser enviado
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
    
    // Enviando a requisição
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

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  @Published var location: CLLocation?
  
  override init() {
    super.init()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func requestLocation() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      self.location = location
      locationManager.stopUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Erro ao obter localização: \(error)")
  }
}

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var selectedImages: [UIImage]
  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 8
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      
      parent.selectedImages.removeAll()
      
      var images: [UIImage] = []
      let group = DispatchGroup()
      
      for result in results {
        group.enter()
        result.itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in
          if let image = image as? UIImage {
            images.append(image)
          }
          group.leave()
        }
      }
      group.notify(queue: .main) {
        self.parent.selectedImages = images
      }
    }
  }
}

#Preview {
  PlantRegisterView()
}
