
import Foundation

// MARK: - Post
struct Post: Codable, Identifiable {
    let userId, id: Int
    let title, body: String
    
}
