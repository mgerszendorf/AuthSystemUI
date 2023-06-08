import SwiftUI

struct SignUpView: View {
    @StateObject var apiService = APIService()
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Join our community!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 30)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.headline)
                TextField("Enter your username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 15)
                Text("Email Address")
                    .font(.headline)
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 15)
                Text("Password")
                    .font(.headline)
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 30)
                Text("Confirm Password")
                    .font(.headline)
                SecureField("Confirm your password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 30)
                
                HStack {
                    Spacer()
                    Button(action: {
                        let credentials = RegisterCredentials(username: username, password: password, email: email, confirmPassword: confirmPassword)
                        apiService.register(credentials: credentials) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    alertTitle = "Success"
                                    alertMessage = "Registration successful."
                                    showingAlert = true
                                case .failure(let error):
                                    alertTitle = "Error"
                                    alertMessage = "Registration failed. Error: \(error)"
                                    showingAlert = true
                                }
                            }
                        }
                    }) {
                        Text("Sign Up")
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
            }
            
            HStack {
                Spacer()
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .font(.footnote)
                            .foregroundColor(Color(red: 48/255, green: 112/255, blue: 109/255))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 20)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
