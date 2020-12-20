import Foundation

/*
 * Intermediate layer between network and application.
 *
 * Manages API access key and request URLs.
 * Handles all request errors and parsing the JSON response. Provides high level API access
 * to the network.
 */
public final class MovieRepository {
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let apiKey = "api_key"
    private let networkRequest: NetworkRequestProtocol

    private var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        return jsonDecoder
    }()

    // NetworkRequest is injected so that we can supply a mock
    // for testing
    public init(_ networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    public func fetchMovies(from endpoint: MovieEndpoint, params: [String: String]? = nil, completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(MovieError.invalidEndpoint))
            return
        }

        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            completion(.failure(MovieError.invalidEndpoint))
            return
        }

        networkRequest.execute(url: url) { result in
            completion(self.parse(result))
        }
    }
    
    public func fetchMovie(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)?api_key=\(apiKey)&append_to_response=videos,credits") else {
            completion(.failure(MovieError.invalidEndpoint))
            return
        }
        
        networkRequest.execute(url: url) { result in
            completion(self.parse(result))
        }
    }

    private func parse<T: Decodable>(_ result: Result<Data, Error>) -> Result<T, Error> {
        switch(result) {
        case .failure(let error):
            return Result.failure(error)
        case .success(let data):
            do {
                let decoded = try jsonDecoder.decode(T.self, from: data)
                return Result.success(decoded)
            } catch {
                return Result.failure(MovieError.serializationError)
            }
        }
    }
}
