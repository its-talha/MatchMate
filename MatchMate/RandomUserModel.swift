//
//  RandomUserModel.swift
//  MatchMate
//
//  Created by Mohammad Talha on 28/09/25.
//

struct APIResponse: Decodable {
    let results: [RandomUser]
}

struct RandomUser: Decodable {
    let login: Login
    let name: Name
    let email: String
    let dob: DOB
    let location: Location
    let picture: Picture

    struct Login: Decodable { let uuid: String }
    struct Name: Decodable { let first: String; let last: String }
    struct DOB: Decodable { let age: Int }
    struct Location: Decodable { let city: String }
    struct Picture: Decodable { let large: String }
}
