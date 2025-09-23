//
//  ProfileViewModelProtocol.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

import SwiftUI

@MainActor
protocol ProfileViewModelProtocol {
    func getUserInfo() async
}
