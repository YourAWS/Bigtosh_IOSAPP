
import SwiftUI

struct UserProfileView: View {
    let user: User
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    Text("Member \(user.member_id)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                    
                    // Closet Link
                    Button(action: {
                        if let url = URL(string: "https://shirtclub.net/public-closet/\(user.member_id)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Go here to view my closet")
                            .font(.body)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // Number of shirts owned (placeholder)
                    ProfileField(label: "Number of shirts owned:", value: "1")
                    
                    // All possible user fields - ProfileField only renders if value exists
                    ProfileField(label: "First Name:", value: user.first_name)
                    ProfileField(label: "Last Name:", value: user.last_name)
                    ProfileField(label: "Nick Name:", value: user.nick_name)
                    ProfileField(label: "General message:", value: user.message)
                    ProfileField(label: "Birthday:", value: user.birthday)
                    ProfileField(label: "Marital Status:", value: user.marital)
                    ProfileField(label: "Interested in meeting:", value: user.meeting)
                    ProfileField(label: "School:", value: user.school)
                    ProfileField(label: "Occupation:", value: user.occupation)
                    ProfileField(label: "Likes:", value: user.like)
                    ProfileField(label: "Dislikes:", value: user.dislike)
                    ProfileField(label: "Things you can buy me:", value: user.buy_me)
                    ProfileField(label: "I am cheering for:", value: user.cheer)
                    ProfileField(label: "My Prediction:", value: user.prediction)
                    
                    // Social Media Section (only if at least one exists)
                    let hasTwitter = user.twitter != nil && !(user.twitter?.isEmpty ?? true)
                    let hasInstagram = user.instagram != nil && !(user.instagram?.isEmpty ?? true)
                    let hasFacebook = user.facebook != nil && !(user.facebook?.isEmpty ?? true)
                    let hasYoutube = user.youtube != nil && !(user.youtube?.isEmpty ?? true)
                    
                    if hasTwitter || hasInstagram || hasFacebook || hasYoutube {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Follow me on my Social Media:")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            HStack(spacing: 16) {
                                if hasTwitter, let twitter = user.twitter {
                                    SocialMediaIcon(platform: "twitter", url: twitter, color: .blue)
                                }
                                if hasInstagram, let instagram = user.instagram {
                                    SocialMediaIcon(platform: "instagram", url: instagram, color: Color(red: 0.9, green: 0.3, blue: 0.5))
                                }
                                if hasFacebook, let facebook = user.facebook {
                                    SocialMediaIcon(platform: "facebook", url: facebook, color: .blue)
                                }
                                if hasYoutube, let youtube = user.youtube {
                                    SocialMediaIcon(platform: "youtube", url: youtube, color: .red)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        }
                    }
                    
                    // Pictures Section (only if at least one picture exists)
                    let hasPic1 = user.pic1 != nil && !(user.pic1?.isEmpty ?? true)
                    let hasPic2 = user.pic2 != nil && !(user.pic2?.isEmpty ?? true)
                    let hasPic3 = user.pic3 != nil && !(user.pic3?.isEmpty ?? true)
                    
                    if hasPic1 || hasPic2 || hasPic3 {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Pictures:")
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    if hasPic1, let pic1 = user.pic1 {
                                        AsyncImage(url: URL(string: "https://shirtclub.net/client/\(user.member_id)/pic/\(pic1)")) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 120)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 120, height: 120)
                                            case .failure(_):
                                                Color.gray.opacity(0.3)
                                                    .frame(width: 120, height: 120)
                                                    .cornerRadius(8)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                    if hasPic2, let pic2 = user.pic2 {
                                        AsyncImage(url: URL(string: "https://shirtclub.net/client/\(user.member_id)/pic/\(pic2)")) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 120)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 120, height: 120)
                                            case .failure(_):
                                                Color.gray.opacity(0.3)
                                                    .frame(width: 120, height: 120)
                                                    .cornerRadius(8)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                    if hasPic3, let pic3 = user.pic3 {
                                        AsyncImage(url: URL(string: "https://shirtclub.net/client/\(user.member_id)/pic/\(pic3)")) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 120)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 120, height: 120)
                                            case .failure(_):
                                                Color.gray.opacity(0.3)
                                                    .frame(width: 120, height: 120)
                                                    .cornerRadius(8)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    
                    Spacer()
                        .frame(height: 40)
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
}

// ProfileField component - ONLY renders if value is not nil and not empty
struct ProfileField: View {
    let label: String
    let value: String?
    
    var body: some View {
        if let value = value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
}

struct SocialMediaIcon: View {
    let platform: String
    let url: String
    let color: Color
    
    var body: some View {
        Button(action: {
            var finalUrl = url
            if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
                finalUrl = "https://\(url)"
            }
            if let validUrl = URL(string: finalUrl) {
                UIApplication.shared.open(validUrl)
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconName(for: platform))
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
    
    private func iconName(for platform: String) -> String {
        switch platform.lowercased() {
        case "twitter":
            return "bird"
        case "instagram":
            return "camera"
        case "facebook":
            return "person.2"
        case "youtube":
            return "play.rectangle"
        default:
            return "link"
        }
    }
}
