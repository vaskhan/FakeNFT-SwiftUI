//
//  FavouriteNftViewModelProtocol.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 24.09.2025.
//

import SwiftUI

@MainActor
protocol FavouriteNftViewModelProtocol {
    func getNftInfo(id: String) async
    
    func updateNftFavoriteList(ids: [String]) async
}
