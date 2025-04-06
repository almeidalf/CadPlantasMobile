//
//  PhotoPickerSectionView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 05/04/25.
//

import SwiftUI

struct PhotoPickerSectionView: View {
  @Binding var selectedImages: [IdentifiableImage]
  @Binding var imageToDelete: IdentifiableImage?
  @Binding var showDeleteConfirmation: Bool

  var onCameraTap: () -> Void
  var onGalleryTap: () -> Void

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 16) {
        Button(action: onCameraTap) {
          Label("Tirar Foto", systemImage: "camera")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }

        Button(action: onGalleryTap) {
          Label("Galeria", systemImage: "photo")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.indigo)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
      }

      if !selectedImages.isEmpty {
        ScrollView(.horizontal) {
          HStack {
            ForEach(selectedImages) { identifiableImage in
              ZStack(alignment: .topTrailing) {
                Image(uiImage: identifiableImage.image)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 200, height: 200)
                  .clipped()
                  .cornerRadius(8)
                  .onTapGesture {
                    imageToDelete = identifiableImage
                    showDeleteConfirmation = true
                  }

                Button {
                  imageToDelete = identifiableImage
                  showDeleteConfirmation = true
                } label: {
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
    }
  }
}

public struct IdentifiableImage: Identifiable, Hashable {
  public let id = UUID()
  public let image: UIImage
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  public static func == (lhs: IdentifiableImage, rhs: IdentifiableImage) -> Bool {
    lhs.id == rhs.id
  }
}
