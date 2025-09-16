//
//  userModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

struct UserModel: Decodable, Hashable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
