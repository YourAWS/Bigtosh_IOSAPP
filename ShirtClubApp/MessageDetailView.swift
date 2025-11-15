import SwiftUI

struct MessageDetailView: View {
    let message: Message
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    Text("Message \(message.message_id)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    Divider()
                    
                    // Message Text Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Message:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let text = message.text, !text.isEmpty {  // Uses the alias 'text' which returns 'content'
                            Text(text)
                                .font(.body)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("No message to display")
                                .font(.body)
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    // Link Section (clickable)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Link:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let link = message.link, !link.isEmpty {
                            Button(action: {
                                openURL(link)
                            }) {
                                Text(link)
                                    .font(.body)
                                    .foregroundColor(.blue)
                                    .underline()
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            Text("No link to display")
                                .font(.body)
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // Image Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Image:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        if let imageURL = message.fullImageURL {
                            AsyncImage(url: URL(string: imageURL)) { phase in
                                switch phase {
                                case .empty:
                                    // Loading state with spinner and placeholder
                                    ZStack {
                                        Color.gray.opacity(0.1)
                                        VStack(spacing: 12) {
                                            ProgressView()
                                                .scaleEffect(1.2)
                                            Text("Loading image...")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .frame(height: 250)
                                    .cornerRadius(8)
                                    
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(8)
                                        .transition(.opacity.animation(.easeIn(duration: 0.3)))
                                        
                                case .failure(let error):
                                    // Error state
                                    ZStack {
                                        Color.gray.opacity(0.1)
                                        VStack(spacing: 8) {
                                            Image(systemName: "exclamationmark.triangle")
                                                .font(.largeTitle)
                                                .foregroundColor(.orange)
                                            Text("Failed to load image")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text(error.localizedDescription)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal)
                                        }
                                    }
                                    .frame(height: 200)
                                    .cornerRadius(8)
                                    
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            Text("No image to display")
                                .font(.body)
                                .foregroundColor(.gray)
                                .italic()
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color("BigToshBlue"))
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        var finalUrl = urlString
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            finalUrl = "https://\(urlString)"
        }
        if let url = URL(string: finalUrl) {
            UIApplication.shared.open(url)
        }
    }
}
