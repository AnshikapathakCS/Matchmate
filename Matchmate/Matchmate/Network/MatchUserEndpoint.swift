import Foundation

struct MatchUserEndpoint: Endpoint {
    let count: Int

    var baseURL: String { "https://randomuser.me" }
    var path: String    { "/api/" }
    var method: HttpMethodType { .GET }
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "results", value: "\(count)")]
    }
}

// MARK: - Response

struct RandomUserResponse: Decodable {
    let results: [APIUser]
}

struct APIUser: Decodable {
    let login: Login
    let name: Name
    let dob: DOB
    let location: Location
    let picture: Picture

    struct Login: Decodable    { let uuid: String }
    struct Name: Decodable     { let first: String; let last: String }
    struct DOB: Decodable      { let age: Int }
    struct Location: Decodable { let city: String; let country: String }
    struct Picture: Decodable  { let large: String }
}

extension MatchUser {
    init(api: APIUser) {
        self.init(
            id: api.login.uuid,
            name: "\(api.name.first) \(api.name.last)",
            age: api.dob.age,
            city: api.location.city,
            country: api.location.country,
            imageURL: api.picture.large
        )
    }
}
