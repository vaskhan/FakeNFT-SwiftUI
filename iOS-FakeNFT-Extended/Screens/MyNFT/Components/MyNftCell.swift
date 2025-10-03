//
//  MyNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 28.09.2025.
//

import SwiftUI

private enum Constants {
    static let imageSize: CGFloat = 108
    static let cornerRadius: CGFloat = 12
}

struct MyNftCell: View {
    @State private var isLiked = true
    private let imageName: String
    private let name: String
    private let author: String
    private let rating: Int
    private let price: Double
    
    init(isLiked: Bool = true, imageName: String, name: String, author: String, rating: Int, price: Double) {
        self.isLiked = isLiked
        self.imageName = imageName
        self.name = name
        self.author = author
        self.rating = rating
        self.price = price
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.gray.opacity(0.1))
                .overlay {
                    if let url = URL(string: imageName) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image("NFTcard")
                                    .resizable()
                                    .scaledToFill()
                                    .font(.appBold32)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.appBold17)
                    HStack(alignment: .center, spacing: 2) {
                        ForEach(0..<5, id: \.self) { index in
                            Image(index < rating ? "YellowStar" : "WhiteStar")
                        }
                    }
                    Text(String(localized: "ProfileFlow.MyNft.by") + " \(author)")
                        .font(.appRegular15)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            
            Spacer()
            
            VStack {
                
                VStack(alignment: .leading, spacing: 2){
                    Text(String(localized: "CartFlow.Cart.itemPrice"))
                        .font(.appRegular13)
                    Text("\(String(format: "%.2f", price)) ETH")
                        .font(.appBold17)
                }
            }
            
        }
    }
}

//#Preview {
//    FavouriteNftCell(imageName: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Calder/1.png", name: "Fhntv", rating: 3, price: 19.84)
//}
