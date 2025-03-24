//
//  LoginView.swift
//  CadPlantas
//
//  Created by Felipe Almeida on 24/03/25.
//

import SwiftUI

struct LoginView: View {
  @AppStorage("token") private var token: String = ""
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var shouldNavigate = false
  @State private var isLoading = false
  @State private var showToast = false
  @State private var toastMessage = ""
  
  var body: some View {
    NavigationStack {
      ZStack {
        VStack(spacing: 16) {
          TextField("E-mail", text: $email)
            .padding()
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(8)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
          
          SecureField("Senha", text: $password)
            .padding()
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(8)
          
          Button(action: {
            let endpoint = LoginEndpoint(email: email, password: password)
            isLoading = true
            sendRequest(endpoint: endpoint)
          }) {
            if isLoading {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary)
                .cornerRadius(8)
            } else {
              Text("Entrar")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.primary)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
          }
          .disabled(isLoading)
        }
        .padding(.horizontal, 16)
        VStack {
          Spacer()
          ToastView(message: toastMessage, isPresented: $showToast)
            .padding(.bottom, 32)
        }
        .animation(.easeInOut, value: showToast)
        .allowsHitTesting(false)
      }
      .navigationDestination(isPresented: $shouldNavigate) {
        MainTabBar()
      }
      .onChange(of: token) { token in
        shouldNavigate = !token.isEmpty
      }
      .onAppear {
        if !token.isEmpty {
          shouldNavigate = true
        }
      }
    }
  }
  
  func sendRequest(endpoint: LoginEndpoint) {
    guard let url = endpoint.fullURL() else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      if let body = endpoint.body {
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
      }
    } catch {
      showErrorToast("Erro ao codificar os dados.")
      isLoading = false
      return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        isLoading = false
      }
      
      if let error = error {
        showErrorToast("Erro de requisição: \(error.localizedDescription)")
        return
      }
      
      guard let data = data else {
        showErrorToast("Nenhum dado retornado.")
        return
      }
      
      do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let receivedToken = json["token"] as? String {
          DispatchQueue.main.async {
            token = receivedToken
          }
        } else {
          showErrorToast("E-mail ou senha inválidos, verefique e tente novamente!")
        }
      } catch {
        showErrorToast("Erro ao processar a resposta.")
      }
    }
    
    task.resume()
  }
  
  func showErrorToast(_ message: String) {
    DispatchQueue.main.async {
      toastMessage = message
      showToast = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        withAnimation {
          showToast = false
        }
      }
    }
  }
}


#Preview {
  LoginView()
}
