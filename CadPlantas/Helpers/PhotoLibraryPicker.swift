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
  @Binding var selectedImages: [IdentifiableImage]
  @Binding var latitude: String
  @Binding var longitude: String

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.filter = .images
    configuration.selectionLimit = 10

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

      var loadedImages: [IdentifiableImage] = []
      let dispatchGroup = DispatchGroup()

      for (index, result) in results.enumerated() {
        dispatchGroup.enter()

        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
          result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            defer { dispatchGroup.leave() }
            if let image = object as? UIImage {
              loadedImages.append(IdentifiableImage(image: image))
            }
          }
        } else {
          dispatchGroup.leave()
        }

        if index == 0, let assetId = result.assetIdentifier {
          let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
          if let asset = assets.firstObject {
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.isSynchronous = true
            options.version = .current

            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { _, _, _, _ in
              DispatchQueue.main.async {
                if let location = asset.location {
                  self.parent.latitude = String(location.coordinate.latitude)
                  self.parent.longitude = String(location.coordinate.longitude)
                } else {
                  self.parent.latitude = "0"
                  self.parent.longitude = "0"
                }
              }
            }
          }
        }
      }

      dispatchGroup.notify(queue: .main) {
        self.parent.selectedImages.append(contentsOf: loadedImages)
      }
    }
  }
}
