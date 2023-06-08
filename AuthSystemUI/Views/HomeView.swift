import SwiftUI
import JWTDecode

struct HomeView: View {
    let keychain = KeychainService(service: "com.Marek.AuthSystemUI")
    let apiService = APIService()
    
    @State private var isLoggedOut = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var username: String {
        if let accessTokenData = keychain.load(key: "accessToken"), let accessToken = String(data: accessTokenData, encoding: .utf8) {
            do {
                let jwt = try decode(jwt: accessToken)
                return jwt.claim(name: "username").string ?? "No username"
            } catch {
                return "Failed to decode JWT: \(error)"
            }
        } else {
            return "No access token"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Username: \(username)")
                    .padding()
                
                Button(action: {
                    apiService.logout() { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                isLoggedOut = true
                            case .failure(let error):
                                isLoggedOut = false
                                alertTitle = "Error"
                                alertMessage = "Logout failed. Error: \(error)"
                                showingAlert = true
                            }
                        }
                    }
                }) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color(red: 48/255, green: 112/255, blue: 109/255))
                        .cornerRadius(15.0)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .background(
                NavigationLink(destination: LoginView(), isActive: $isLoggedOut) {
                    EmptyView()
                }
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
