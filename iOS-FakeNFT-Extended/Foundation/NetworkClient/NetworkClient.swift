import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

// Протокол сетевого клиента
protocol NetworkClient {
    func send(urlRequest: URLRequest) async throws -> Data
    func send<T: Decodable>(urlRequest: URLRequest) async throws -> T
}

// Реализация сетевого клиента на URLSession
actor DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let commonHeaders: [String: String]
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        token: String = RequestConstants.token
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.commonHeaders = [
            "X-Practicum-Mobile-Token": token
        ]
    }
    
    // Отправить запрос и вернуть «сырые» данные
    func send(urlRequest: URLRequest) async throws -> Data {
        let prepared = applyCommonHeaders(to: urlRequest)
        let (data, response) = try await session.data(for: prepared)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }
        guard 200..<300 ~= http.statusCode else {
            throw NetworkClientError.httpStatusCode(http.statusCode)
        }
        return data
    }
    
    // для отправки запроса и сразу распарсить JSON в модель Decodable
    func send<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        let data = try await send(urlRequest: urlRequest)
        return try parse(data: data)
    }
    
    // Добавляет заголовки
    private func applyCommonHeaders(to request: URLRequest) -> URLRequest {
        var request = request
        for (field, value) in commonHeaders {
            if request.value(forHTTPHeaderField: field) == nil {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        return request
    }
    // Для декодирования ответа сервера в модель Decodable
    private func parse<T: Decodable>(data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkClientError.parsingError
        }
    }
}
