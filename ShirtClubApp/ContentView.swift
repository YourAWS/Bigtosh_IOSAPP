import SwiftUI

struct ContentView: View {
    @State private var shirtNumber: String = ""
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var selectedUser: User? = nil
    @State private var selectedMessage: Message? = nil
    @State private var showUserProfile: Bool = false
    @State private var showMessageDetail: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    // Error Message
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .bold()
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }
                    
                    // Heading
                    Text("See a number on a shirt? Enter it here to see this shirt's message")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    
                    // Text Field
                    TextField("Enter a number", text: $shirtNumber)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        .onChange(of: shirtNumber) { _ in
                            if errorMessage != nil {
                                errorMessage = nil
                            }
                        }
                    
                    // Search Button
                    Button(action: {
                        searchShirt()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                        } else {
                            Text("Search Number")
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                        }
                    }
                    .background(Color("BigToshBlue"))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .disabled(isLoading)
                    
                    // Dynamic spacing
                    Spacer()
                        .frame(height: geometry.size.height < 700 ? 60 : 115)
                    
                    // Combined Logo
                    Image("combined_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 215)
                        .padding(.horizontal, 20)
                    
                    // Dynamic spacer
                    Spacer()
                        .frame(height: geometry.size.height < 700 ? 60 : 135)
                    
                    // Login Links
                    Button(action: {
                        if let url = URL(string: "https://shirtclub.net") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Login to Shirtclub.net")
                            .font(.system(size: 14))
                            .foregroundColor(Color("BigToshBlue"))
                    }
                    .padding(.top, 8)
                    
                    Button(action: {
                        if let url = URL(string: "https://shirtclub.net") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Login to Big Tosh")
                            .font(.system(size: 14))
                            .foregroundColor(Color("BigToshBlue"))
                    }
                    .padding(.top, 12)
                    
                    Spacer()
                        .frame(height: 30)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .sheet(isPresented: $showUserProfile) {
            if let user = selectedUser {
                UserProfileView(user: user)
            }
        }
        .sheet(isPresented: $showMessageDetail) {
            if let message = selectedMessage {
                MessageDetailView(message: message)
            }
        }
    }
    
    private func searchShirt() {
        if shirtNumber.isEmpty {
            errorMessage = "Please enter a number."
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        ApiClient.shared.searchShirtOrUser(code: shirtNumber) { result in
            isLoading = false
            
            switch result {
            case .success(let response):
                // Check if user found
                if let user = response.user {
                    selectedUser = user
                    showUserProfile = true
                }
                // Check if message found
                else if let message = response.message {
                    handleMessage(message)
                }
                // Check if inactive user
                else if response.inactive == true {
                    errorMessage = "This user's membership is inactive."
                }
                // Nothing found
                else {
                    errorMessage = "No message or user found for this number."
                }
                
            case .failure(let error):
                if let apiError = error as? ApiError {
                    errorMessage = apiError.localizedDescription
                } else {
                    errorMessage = "No message or user found for this number."
                }
            }
        }
    }
    
    private func handleMessage(_ message: Message) {
        // Check if this is a "gp" message (direct link)
        if message.isDirectLinkMessage {
            // Open the link directly in browser
            if let link = message.link, !link.isEmpty {
                openURLInBrowser(link)
            } else {
                errorMessage = "This message has no link associated."
            }
        } else {
            // Show the message detail view
            selectedMessage = message
            showMessageDetail = true
        }
    }
    
    private func openURLInBrowser(_ urlString: String) {
        var finalUrl = urlString
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            finalUrl = "https://\(urlString)"
        }
        if let url = URL(string: finalUrl) {
            UIApplication.shared.open(url)
        } else {
            errorMessage = "Invalid URL format."
        }
    }
}
