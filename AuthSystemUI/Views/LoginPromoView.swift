import SwiftUI

struct LoginPromoView: View {
    @State private var isShowingSignUp = false
    @State private var isShowingLogin = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Spacer()
                
                Image("nature")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 50)
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Let's Get Started")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Start segregating waste now and let's take care of our planet together!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .padding(.bottom, 30)
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Spacer()
                        NavigationLink(destination: SignUpView(), isActive: $isShowingSignUp) {
                            Button(action: {
                                isShowingSignUp = true
                            }) {
                                Text("Join Now")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 48/255, green: 112/255, blue: 109/255))
                                    .padding()
                                    .frame(width: 220, height: 60)
                                    .background(.white)
                                    .cornerRadius(15.0)
                            }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        HStack {
                            Text("Already have an account?")
                                .font(.footnote)
                                .foregroundColor(.white)
                            NavigationLink(destination: LoginView()) {
                                Text("Login")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.bottom, 20)
                        Spacer()
                    }
                    .padding()
                }
                Spacer()
                
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(red: 48/255, green: 112/255, blue: 109/255))
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct LoginPromoView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPromoView()
    }
}
