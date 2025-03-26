//
//  ImagePicker.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 25/03/25.
//

import SwiftUI
import Photos
import PhotosUI

struct PhotoLibraryPicker: UIViewControllerRepresentable {
  @Binding var selectedImages: [UIImage]
  @Binding var latitude: String
  @Binding var longitude: String

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.filter = .images
    configuration.selectionLimit = 10 // Permite múltiplas imagens

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: PhotoLibraryPicker

    init(_ parent: PhotoLibraryPicker) {
      self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)

      for (index, result) in results.enumerated() {
        // Carrega imagem visual
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
          result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self else { return }
            if let image = object as? UIImage {
              DispatchQueue.main.async {
                self.parent.selectedImages.append(image)
              }
            }
          }
        }

        // Pega coordenadas apenas da primeira imagem selecionada
        if index == 0, let assetId = result.assetIdentifier {
          let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
          if let asset = assets.firstObject {
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.isSynchronous = true
            options.version = .current

            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { _, _, _, _ in
              if let location = asset.location {
                DispatchQueue.main.async {
                  self.parent.latitude = String(location.coordinate.latitude)
                  self.parent.longitude = String(location.coordinate.longitude)
                  print("📍 Coordenadas da primeira imagem: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                }
              } else {
                print("⚠️ Primeira imagem não contém dados de localização.")
              }
            }
          } else {
            print("❌ Asset da primeira imagem não encontrado.")
          }
        }
      }
    }
  }
}
