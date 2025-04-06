//
//  CameraPicker.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 25/03/25.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
  @Binding var selectedImages: [IdentifiableImage]

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    picker.sourceType = .camera
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: CameraPicker

    init(_ parent: CameraPicker) {
      self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true)
      if let image = info[.originalImage] as? UIImage {
        let identifiable = IdentifiableImage(image: image)
        parent.selectedImages.append(identifiable)
      }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
    }
  }
}
