//
//  ProfileRoute.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 21.09.2025.
//
enum ProfileRoute: Hashable {
    case myNFTs(myNftList: [String])
    case favoriteNFTs
    case profileEditing
}
