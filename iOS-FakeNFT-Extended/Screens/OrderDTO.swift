struct OrderDTO: Decodable, Sendable {
    let nfts: [String]?
    let id: String
}
