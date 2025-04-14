import SwiftUI
import MapKit
import CoreLocation

struct MapSheetView: View {
  let latitude: Double
  let longitude: Double

  @Environment(\.dismiss) private var dismiss
  @State private var cameraPosition: MapCameraPosition = .automatic
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    NavigationStack {
      VStack(spacing: 8) {
        Map(position: $cameraPosition) {
          // Ponto da espécie
          Annotation("Espécie", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
            Image(systemName: "leaf.fill")
              .foregroundColor(.green)
              .padding(8)
              .background(.white)
              .clipShape(Circle())
              .shadow(radius: 3)
          }

          // Ponto do usuário
          if let userCoord = locationManager.location?.coordinate {
            UserAnnotation()

            Annotation("Você", coordinate: userCoord) {
              Image(systemName: "person.circle.fill")
                .foregroundColor(.blue)
                .font(.title2)
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 2)
            }
          }
        }
        .mapStyle(.standard)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        // Distância e botão de rota
        if let userCoord = locationManager.location?.coordinate {
          let distance = calculateDistance(from: userCoord, to: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))

          VStack(spacing: 8) {
            Text("Você está a aproximadamente \(distance) metros da espécie.")
              .font(.caption)
              .foregroundColor(.secondary)

            Button("Traçar rota no Mapas") {
              openRouteInAppleMaps(
                from: userCoord,
                to: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
              )
            }
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.15))
            .foregroundColor(.blue)
            .clipShape(Capsule())
          }
          .padding(.bottom, 8)
        }
      }
      .navigationTitle("Localização da Espécie")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Fechar") {
            dismiss()
          }
        }
      }
      .onAppear {
        locationManager.requestLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          cameraPosition = .camera(
            MapCamera(
              centerCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
              distance: 350,
              heading: 30,
              pitch: 50
            )
          )
        }
      }
    }
  }

  func calculateDistance(from coord1: CLLocationCoordinate2D, to coord2: CLLocationCoordinate2D) -> String {
    let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
    let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
    let distance = loc1.distance(from: loc2) // em metros
    return String(format: "%.0f", distance)
  }

  func openRouteInAppleMaps(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
    let source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
    source.name = "Você"

    let dest = MKMapItem(placemark: MKPlacemark(coordinate: destination))
    dest.name = "Espécie"

    MKMapItem.openMaps(with: [source, dest], launchOptions: [
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
    ])
  }
}
