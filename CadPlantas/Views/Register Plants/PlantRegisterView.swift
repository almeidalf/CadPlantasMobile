import SwiftUI

enum FieldType: Identifiable {
  case leaf, stem, inflorescence, fruit

  var id: String {
    switch self {
    case .leaf: return "leaf"
    case .stem: return "stem"
    case .inflorescence: return "inflorescence"
    case .fruit: return "fruit"
    }
  }
}

struct FieldSheetData: Identifiable {
  var id: String { field.id }
  let field: FieldType
  let options: [String]
  let showColorPicker: Bool
}

struct PlantRegisterView: View {
  @AppStorage("token") private var token: String = ""
  @State private var sheetData: FieldSheetData?
  @State private var selectedImages: [IdentifiableImage] = []
  
  @State private var name = ""
  @State private var nameScientific = ""
  @State private var description = ""
  @State private var latitude = ""
  @State private var longitude = ""
  @State private var leaves: [String] = []
  @State private var stem: [String] = []
  @State private var inflorescence: [String] = []
  @State private var fruit: [String] = []
  @State private var colors: [String] = []
  @State private var isPublic: Bool = true

  @State private var leafSelected = ""
  @State private var leafColorSelected = ""
  @State private var stemSelected = ""
  @State private var inflorescenceSelected = ""
  @State private var inflorescenceColorSelected = ""
  @State private var fruitSelected = ""
  @State private var fruitColorSelected = ""

  @StateObject private var locationManager = LocationManager()
  @State private var showAlert = false
  @State private var alertMessage = ""
  @State private var showCameraPicker = false
  @State private var showPhotoLibraryPicker = false
  @State private var imageToDelete: IdentifiableImage?
  @State private var showDeleteConfirmation = false

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 16) {
          FormHeaderView(name: $name, nameScientific: $nameScientific, description: $description)

          MorphologicalSectionView(
            leaves: leaves,
            stem: stem,
            inflorescence: inflorescence,
            fruit: fruit,
            colors: colors,
            leafSelected: $leafSelected,
            leafColorSelected: $leafColorSelected,
            stemSelected: $stemSelected,
            inflorescenceSelected: $inflorescenceSelected,
            inflorescenceColorSelected: $inflorescenceColorSelected,
            fruitSelected: $fruitSelected,
            fruitColorSelected: $fruitColorSelected,
            sheetData: $sheetData
          )

          LocationDisplayView(latitude: latitude, longitude: longitude)
          
          PhotoPickerSectionView(
            selectedImages: $selectedImages,
            imageToDelete: $imageToDelete,
            showDeleteConfirmation: $showDeleteConfirmation,
            onCameraTap: {
              showCameraPicker = true
            },
            onGalleryTap: {
              showPhotoLibraryPicker = true
            }
          )
          
          Section(header: Text("Cadastrar planta como pública?")) {
            Picker("Planta pública?", selection: $isPublic) {
              Text("Sim").tag(true)
              Text("Não").tag(false)
            }
            .pickerStyle(.segmented)
          }

          SubmitButtonView(isValid: isValid) {
            submitForm()
          }
        }
        .padding(16)
        .sheet(item: $sheetData) { data in
          SelectionListView(
            title: fieldTitle(for: data.field),
            options: data.options,
            colors: data.field == .stem ? [] : colors,
            selectedType: bindingForSelectedType(field: data.field),
            selectedColor: bindingForSelectedColor(field: data.field),
            onSelectType: { selected in assignSelected(selected, for: data.field, isColor: false) },
            onSelectColor: { selectedColor in assignSelected(selectedColor, for: data.field, isColor: true) }
          )
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
        .alert(isPresented: $showAlert) {
          Alert(title: Text("Atenção"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .confirmationDialog("Deseja remover esta imagem?", isPresented: $showDeleteConfirmation) {
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
        .onAppear {
          getRequest()
        }
        .navigationTitle("Cadastro de Plantas")
        .navigationBarTitleDisplayMode(.inline)
      }
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
        leaf: leafSelected,
        leafColor: leafColorSelected,
        stem: stemSelected,
        inflorescence: inflorescenceSelected,
        inflorescenceColor: inflorescenceColorSelected,
        fruit: fruitSelected,
        fruitColor: fruitColorSelected,
        images: selectedImages,
        isPublic: isPublic
      )
      let endpoint = PlantEndpoint(plant: plant)
      sendRequest(endpoint: endpoint)
    } else {
      alertMessage = "Preencha todos os campos e adicione pelo menos uma imagem!"
    }
    showAlert = true
  }

  @MainActor
  func sendRequest(endpoint: PlantEndpoint) {
    guard let url = endpoint.fullURL() else { return }

    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
      if let body = endpoint.body {
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
      }
    } catch {
      alertMessage = "Erro ao codificar os dados: \(error.localizedDescription)"
      showAlert = true
      return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        Task { @MainActor in
          alertMessage = "Erro de requisição: \(error.localizedDescription)"
          showAlert = true
        }
        return
      }

      guard let data = data else {
        Task { @MainActor in
          alertMessage = "Resposta vazia do servidor."
          showAlert = true
        }
        return
      }

      do {
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let message = json["message"] as? String {
          Task { @MainActor in
            alertMessage = message
            showAlert = true
          }
        } else {
          Task { @MainActor in
            alertMessage = "Resposta inesperada do servidor."
            showAlert = true
          }
        }
      } catch {
        Task { @MainActor in
          alertMessage = "Erro ao processar resposta: \(error.localizedDescription)"
          showAlert = true
        }
      }
    }

    task.resume()
  }

  @MainActor
  func getRequest() {
    guard let url = URL(string: AppEnvironment.baseURL + "/api/v1/plants/parts") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else { return }

      do {
        let decodedResponse = try JSONDecoder().decode(PlantPartsResponse.self, from: data)
        DispatchQueue.main.async {
          leaves = decodedResponse.leaves ?? []
          stem = decodedResponse.stem ?? []
          inflorescence = decodedResponse.inflorescence ?? []
          fruit = decodedResponse.fruit ?? []
          colors = decodedResponse.colors ?? []
        }
      } catch {
        print("Erro ao decodificar resposta: \(error)")
      }
    }

    task.resume()
  }

  func fieldTitle(for field: FieldType) -> String {
    switch field {
    case .leaf: return "Folha"
    case .stem: return "Caule"
    case .inflorescence: return "Inflorescência"
    case .fruit: return "Fruto"
    }
  }

  func assignSelected(_ value: String, for field: FieldType, isColor: Bool) {
    switch field {
    case .leaf:
      if isColor {
        leafColorSelected = value
      } else {
        leafSelected = value
        leafColorSelected = ""
      }
    case .stem:
      stemSelected = value
    case .inflorescence:
      if isColor {
        inflorescenceColorSelected = value
      } else {
        inflorescenceSelected = value
        inflorescenceColorSelected = ""
      }
    case .fruit:
      if isColor {
        fruitColorSelected = value
      } else {
        fruitSelected = value
        fruitColorSelected = ""
      }
    }
  }
  
  func bindingForSelectedType(field: FieldType) -> Binding<String> {
    switch field {
    case .leaf: return $leafSelected
    case .stem: return $stemSelected
    case .inflorescence: return $inflorescenceSelected
    case .fruit: return $fruitSelected
    }
  }

  func bindingForSelectedColor(field: FieldType) -> Binding<String> {
    switch field {
    case .leaf: return $leafColorSelected
    case .stem: return .constant("") // não tem cor
    case .inflorescence: return $inflorescenceColorSelected
    case .fruit: return $fruitColorSelected
    }
  }
}

#Preview {
  PlantRegisterView()
}
