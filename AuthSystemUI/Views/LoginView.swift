import SwiftUI

struct LoginView: View {
    @StateObject var apiService = APIService()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome Back! 👋")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Hello again, you've been missed!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 30)
            
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                TextField("Enter email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 15)
                Text("Password")
                    .font(.headline)
                SecureField("Enter password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 30)
                
                HStack {
                    Spacer()
                    Button(action: {
                        let credentials = LoginCredentials(email: email, password: password)
                        apiService.login(credentials: credentials) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    isLoggedIn = true
                                case .failure(let error):
                                    if !isLoggedIn {
                                        alertTitle = "Error"
                                        alertMessage = "Login failed. Error: \(error)"
                                        showingAlert = true
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Login")
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
                    Spacer()
                }
                .padding()
            }
            
            HStack {
                Spacer()
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .font(.footnote)
                            .foregroundColor(Color(red: 48/255, green: 112/255, blue: 109/255))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 20)
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        .background(
            NavigationLink("Login Screen",destination: HomeView(), isActive: $isLoggedIn)
                .hidden()
        )
        .navigationBarBackButtonHidden(true)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
