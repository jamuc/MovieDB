import Foundation

/*
 * Network request layer API. Implemented this way so that we can
 * mock the network request layer in the testing framework.
 */
public protocol NetworkRequestProtocol {
    func execute(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

/*
 * Networklayer of the application. Handle the URLSession and loading data from the newtwork.
 */
public class NetworkRequest: NetworkRequestProtocol {

    public init() {}
    public func execute(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(MovieError.apiError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(MovieError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(MovieError.noData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
