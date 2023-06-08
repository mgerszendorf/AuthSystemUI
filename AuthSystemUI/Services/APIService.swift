import Foundation

struct LoginResult: Codable {
    let accessToken: String
    let refreshToken: String
}

struct LoginResponse: Codable {
    let status: Int
    let data: LoginResult?
}

struct LoginCredentials: Codable {
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let status: Int
}

struct RegisterCredentials: Codable {
    let username: String
    let password: String
    let email: String
    let confirmPassword: String
}

class APIService: ObservableObject {
    let baseURL = URL(string: "http://localhost:50000/api/v1")
    
    func login(credentials: LoginCredentials, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = baseURL?.appendingPathComponent("/accounts/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(credentials)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey : "Login failed"])))
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                guard let token = loginResponse.data else {
                    return
                }
                
                let keychain = KeychainService(service: "com.Marek.AuthSystemUI")
                let accessTokenData = Data(token.accessToken.utf8)
                let refreshTokenData = Data(token.refreshToken.utf8)
                
                keychain.save(key: "accessToken", data: accessTokenData)
                keychain.save(key: "refreshToken", data: refreshTokenData)
                
                completion(.success(loginResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func register(credentials: RegisterCredentials, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        guard let url = baseURL?.appendingPathComponent("/accounts/register") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(credentials)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201, let data = data else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey : "Registration failed"])))
                return
            }

            do {
                let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                completion(.success(registerResponse))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        let keychain = KeychainService(service: "com.Marek.AuthSystemUI")
        
        guard let accessToken = keychain.load(key: "accessToken") else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey : "No access token found"])))
            return
        }
        
        guard let url = baseURL?.appendingPathComponent("/accounts/logout") else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey : "Invalid endpoint URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let _ = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey : "Request failed"])))
                return
            }
            
            if httpResponse.statusCode == 401 {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey : "Unauthorized"])))
                return
            }
            
            keychain.delete(key: "accessToken")
            keychain.delete(key: "refreshToken")
            
            completion(.success(true))
        }
        
        task.resume()
    }

}
