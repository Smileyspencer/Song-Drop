//
//  Song_DropApp.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/3/24.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

class AuthStateViewModel: ObservableObject {
    
    @Injected(\.authStateManager) var authStateManager
    
    @Published var signedIn = false
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        FirebaseApp.configure()
        signedIn = authStateManager.isSignedIn()
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            Task {
                await MainActor.run {
                    if Auth.auth().currentUser != nil {
                        self.signedIn = true
                    } else {
                        self.signedIn = false
                    }
                }
            }
        }
    }
    
    deinit {
        if let handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
}

@main
struct Song_DropApp: App {
    
    @Injected(\.spotifyRemote) var spotifyRemote
    @Injected(\.spotifyRepo) var spotifyRepo
    @Injected(\.sharedModelContainer) var sharedModelContainer
    
    @ObservedObject var viewModel = AuthStateViewModel()
    
    var body: some Scene {
        WindowGroup {
            if viewModel.signedIn {
                SongDropMainMapView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                        if let _ = spotifyRemote.appRemote.connectionParameters.accessToken {
                            spotifyRemote.appRemote.connect()
                        }
                    }
                    .onOpenURL { url in
                        spotifyRemote.handleAuthenticationRedirect(url: url)
                        
                    }
                    .onAppear {
                        Task {
                            await spotifyRepo.getAccessToken()
                        }
                    }
            } else {
                LandingPage()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

struct LandingPage: View {
    
    @State var showSignIn = false
    @State var showSignUp = false
    
    var body: some View {
        VStack {
            Button("Sign In") {
                showSignIn = true
            }
            
            Button("Sign Up") {
                showSignUp = true
            }
        }
        .sheet(isPresented: $showSignIn) {
            AuthPage(mode: .signIn, showingModal: $showSignIn)
        }
        .sheet(isPresented: $showSignUp) {
            AuthPage(mode: .signUp, showingModal: $showSignUp)
        }
    }
}

struct AuthPage: View {
    
    @Injected(\.authStateManager) var authStateManager
    
    enum Mode {
        case signIn, signUp
    }
    
    var mode: Mode
    
    @Binding var showingModal: Bool
    @State var email: String = ""
    @State var password: String = ""
    
    @State var showActivity = false
    
    var body: some View {
        ZStack {
            VStack {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Button(mode == .signIn ? "Sign In" : "Sign Up") {
                    Task {
                        await MainActor.run {
                            showActivity = true
                        }
                        if mode == .signIn {
                            switch await authStateManager.signIn(email: email, password: password) {
                            case .success(_):
                                showingModal = false
                            case .failure(_):
                                break
                            }
                        } else {
                            switch await authStateManager.signUp(email: email, password: password) {
                            case .success(_):
                                showingModal = false
                            case .failure(_):
                                break
                            }
                        }
                        await MainActor.run {
                            showActivity = false
                        }
                    }
                }
            }
            
            if showActivity {
                ProgressView()
            }
        }
    }
}

// sd_test_1@sharklasers.com
class AuthStateManager {
    
    enum AuthStateError: Error {
        case general(_ error: Error)
        case authResultError
    }
    
    func isSignedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }

    func signIn(email: String, password: String) async -> Result<AuthDataResult, AuthStateError> {
        return await withCheckedContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error {
                    INFO("Error when signing in.")
                    continuation.resume(returning: .failure(.general(error)))
                    return
                }
                
                guard let authResult else {
                    INFO("No auth result when signing in.")
                    continuation.resume(returning: .failure(.authResultError))
                    return
                }
                continuation.resume(returning: .success(authResult))
            }
        }
    }
    
    func signUp(email: String, password: String) async -> Result<AuthDataResult, AuthStateError> {
        return await withCheckedContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error {
                    INFO("Error when signing up.")
                    continuation.resume(returning: .failure(.general(error)))
                    return
                }
                
                guard let authResult else {
                    INFO("No auth result when signing up.")
                    continuation.resume(returning: .failure(.authResultError))
                    return
                }
                continuation.resume(returning: .success(authResult))
            }
        }
    }
}
