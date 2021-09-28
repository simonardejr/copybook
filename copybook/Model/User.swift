
import Foundation

// MARK: - User
struct User: Codable, Identifiable {
    let id: Int
    var name, username, email: String
    let address: AddressOld
    let phone, website: String
    let company: Company
    
    init(name: String, username: String, email: String) {
        self.id = UUID().hashValue
        self.name = name
        self.username = username
        self.email = email
        self.phone = ""
        self.website = ""
        
        self.address = AddressOld(street: "", suite: "", city: "", zipcode: "", geo: Geo(lat: "", lng: ""))
        self.company = Company(name: "", catchPhrase: "", bs: "")
    }
}

// MARK: - Address
struct AddressOld: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}
