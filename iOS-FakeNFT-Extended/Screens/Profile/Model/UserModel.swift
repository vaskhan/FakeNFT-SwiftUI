//
//  userModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

struct UserModel: Decodable, Hashable {
    var name: String
    var avatar: String
    var description: String?
    var website: String
    var nfts: [String]
    var likes: [String]
    let id: String
}
