import Foundation

// MARK: - API Response
struct ApiResponse: Codable {
    let user: User?
    let auth: Bool?
    let inactive: Bool?
    let fail: String?
    
    // Message can be either a single Message object OR an array of messages OR false/null
    private let messageValue: MessageValue?
    
    // Computed property to get single message
    var message: Message? {
        switch messageValue {
        case .single(let msg):
            return msg
        case .array(_):
            return nil
        case .none:
            return nil
        }
    }
    
    // Computed property to get array of messages (for user profile)
    var messages: [Message]? {
        switch messageValue {
        case .array(let msgs):
            return msgs
        case .single(_):
            return nil
        case .none:
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case messageValue = "message"
        case user, auth, inactive, fail
    }
    
    // Custom decoding to handle message being either object, array, or false
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user = try container.decodeIfPresent(User.self, forKey: .user)
        auth = try container.decodeIfPresent(Bool.self, forKey: .auth)
        inactive = try container.decodeIfPresent(Bool.self, forKey: .inactive)
        fail = try container.decodeIfPresent(String.self, forKey: .fail)
        
        // Try to decode message as object first, then as array, then as bool/null
        if let singleMessage = try? container.decode(Message.self, forKey: .messageValue) {
            messageValue = .single(singleMessage)
        } else if let messageArray = try? container.decode([Message].self, forKey: .messageValue) {
            messageValue = .array(messageArray)
        } else if let messageBool = try? container.decode(Bool.self, forKey: .messageValue), !messageBool {
            messageValue = nil
        } else {
            messageValue = nil
        }
    }
    
    // Custom encoding to conform to Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(auth, forKey: .auth)
        try container.encodeIfPresent(inactive, forKey: .inactive)
        try container.encodeIfPresent(fail, forKey: .fail)
        
        // Encode message value based on its type
        switch messageValue {
        case .single(let msg):
            try container.encode(msg, forKey: .messageValue)
        case .array(let msgs):
            try container.encode(msgs, forKey: .messageValue)
        case .none:
            try container.encodeNil(forKey: .messageValue)
        }
    }
}

// Helper enum to handle different message response types
enum MessageValue {
    case single(Message)
    case array([Message])
}

// MARK: - Message Model
struct Message: Codable {
    let message_id: String
    let member_id: String?
    let content: String?  // Changed from 'text' to 'content'
    let link: String?
    let image: String?    // Changed from 'pic' to 'image'
    let type: String?
    let created_at: String?
    
    // Computed property to check if this is a "gp" message
    var isDirectLinkMessage: Bool {
        return message_id.lowercased().hasPrefix("gp")
    }
    
    // Helper to check if image exists
    var hasImage: Bool {
        return image != nil && !(image?.isEmpty ?? true)
    }
    
    // Helper to get full image URL
    var fullImageURL: String? {
        guard let image = image, !image.isEmpty else {
            return nil
        }
        
        // The image field already contains the full path like "/client/SC0049/pic/3WhW1JeVy1ls"
        // So we just need to prepend the domain
        if image.hasPrefix("/") {
            return "https://shirtclub.net\(image)"
        }
        
        // Fallback: if it's just a filename
        if let memberId = member_id, !memberId.isEmpty {
            return "https://shirtclub.net/client/\(memberId)/pic/\(image)"
        }
        
        return nil
    }
    
    // Alias for backward compatibility
    var text: String? { content }
    var pic: String? { image }
}

// MARK: - User Model
struct User: Codable {
    let member_id: String
    let first_name: String?
    let last_name: String?
    let nick_name: String?
    let message: String?
    let birthday: String?
    let marital: String?
    let meeting: String?
    let school: String?
    let occupation: String?
    let like: String?
    let dislike: String?
    let buy_me: String?
    let cheer: String?
    let prediction: String?
    let pic1: String?
    let pic2: String?
    let pic3: String?
    let twitter: String?
    let instagram: String?
    let facebook: String?
    let youtube: String?
    let membership_status: String?
}
