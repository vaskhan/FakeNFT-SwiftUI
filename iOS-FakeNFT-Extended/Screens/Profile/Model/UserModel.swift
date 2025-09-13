//
//  userModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

struct nftModel: Hashable {
    let id: String
}

struct likeModel: Hashable {
    let id: String
}

struct userModel: Hashable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [nftModel]
    let likes: [likeModel]
    let id: String
}
