//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 23.09.2025.
//

import Foundation

protocol CartServiceProtocol {
    func loadCart() async throws -> OrderDTO
    func updateCart(_ itemIds: [String]) async throws
    func getCurrencies() async throws -> [PaymentMethod]
    func buy(currencyId: String) async throws -> Bool
}
actor CartService: CartServiceProtocol {
     private let networkClient: NetworkClient
     
     init(networkClient: NetworkClient) {
         self.networkClient = networkClient
     }
     
     func loadCart() async throws -> OrderDTO {
         let request = try APIRequestBuilder.makeRequest(
            from: APIEndpoint.Orders.list,
            query: nil,
            body: nil
         )
         
         let order: OrderDTO = try await networkClient.send(urlRequest: request)
         return order
     }
    
    func updateCart(_ itemIds: [String]) async throws {
        let parameters: [String: Any] = ["nfts": itemIds]
        
        let request = try APIPutRequestBuilder.makeFormURLEncodedRequest(
            from: APIEndpoint.Orders.update,
            parameters: parameters
        )
        
        let (data, response) = try await networkClient.send(urlRequest: request)
        
        if response.statusCode != 200 {
            print("Ошибка сохранения корзины: статус код \(response.statusCode)")
            
            if let responseBody = String(data: data, encoding: .utf8) {
                print("Тело ответа: \(responseBody)")
            }
            
            throw URLError(.badServerResponse)
        }
    }
    
    func getCurrencies() async throws -> [PaymentMethod] {
        let request = try APIRequestBuilder.makeRequest(
            from: APIEndpoint.Currencies.list,
            query: nil,
            body: nil
        )
        
        let currencies: [Currency] = try await networkClient.send(urlRequest: request)
        let paymentMethods = currencies.map { currency in
            PaymentMethod(
                id: currency.id,
                name: currency.title,
                shortName: currency.name,
                icon: URL(string: currency.image)
            )
        }
        return paymentMethods
    }
    
    func buy(currencyId: String) async throws -> Bool {
        let request = try APIRequestBuilder.makeRequest(
            from: APIEndpoint.Orders.buy(id: currencyId),
            query: nil,
            body: nil
        )
        let purchase: PurchaseDTO = try await networkClient.send(urlRequest: request)
        if purchase.success {
            return true
        } else {
            return false
        }
    }
}
