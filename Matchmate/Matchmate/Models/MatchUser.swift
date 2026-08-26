import Foundation

enum MatchStatus {
    case pending
    case accepted
    case declined
}

struct MatchUser: Identifiable {
    let id: String
    let name: String
    let age: Int
    let city: String
    let country: String
    let imageURL: String
    var status: MatchStatus = .pending
}

extension MatchUser {
    static let sampleData: [MatchUser] = [
        MatchUser(id: "1", name: "Ananya Sharma",  age: 27, city: "Mumbai",    country: "India", imageURL: ""),
        MatchUser(id: "2", name: "Rohan Mehta",    age: 30, city: "Bengaluru", country: "India", imageURL: ""),
        MatchUser(id: "3", name: "Sara Khan",      age: 26, city: "Delhi",     country: "India", imageURL: ""),
        MatchUser(id: "4", name: "Vikram Patel",   age: 29, city: "Pune",      country: "India", imageURL: ""),
        MatchUser(id: "5", name: "Priya Iyer",     age: 28, city: "Chennai",   country: "India", imageURL: ""),
        MatchUser(id: "6", name: "Aditya Nair",    age: 31, city: "Hyderabad", country: "India", imageURL: ""),
        MatchUser(id: "7", name: "Meera Joshi",    age: 25, city: "Jaipur",    country: "India", imageURL: "")
    ]
}
