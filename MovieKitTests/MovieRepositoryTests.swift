//
//  MovieRepositoryTests.swift
//  MovieKitTests
//
//  Created by Jason Franklin on 13.12.20.
//

import XCTest
@testable import MovieKit

class MovieRepositoryTests: XCTestCase {

    func testFetchMoviesForTopRatedEndpoint() throws {
        let sut = MovieRepository(MockSuccessfulFetchMoviesRequest())

        sut.fetchMovies(from: MovieEndpoint.topRated) { result in
            switch(result) {
            case .failure(let error):
                assertionFailure("Top rated endpoint should not have failed. Error: \(error)")
                break
            case .success(let response):
                XCTAssertEqual(response.page, 1)
                XCTAssertEqual(response.totalPages, 405)

                let movie = response.results.first
                XCTAssertEqual(movie?.title, "Gabriel's Inferno Part III")
            }
        }
    }
    
    func testFetchMoviesWithServerError() throws {
        let sut = MovieRepository(MockFailedFetchMoviesRequest())

        sut.fetchMovies(from: MovieEndpoint.topRated) { result in
            switch(result) {
            case .success(_):
                assertionFailure("Expected API error to be raised.")
                break
            case .failure(let error):
                if let movieError = error as? MovieError {
                    XCTAssertEqual(movieError, MovieError.apiError)
                    break
                }
                assertionFailure("Error raised in not a MovieError. Error: \(error)")
            }
        }
    }

    func testFetchMovieWithValidID() throws {
        let sut = MovieRepository(MockSuccessfulFetchMovieRequest())
        sut.fetchMovie(id: 1) { result in
            switch(result) {
            case .failure(let error):
                assertionFailure("Expected this test to pass. It failed with error \(error)")
                break
            case .success(let movie):
                XCTAssertEqual(movie.title, "Fight Club")
            }
        }
    }
    func testFetchMovieWithInvalidID() throws {
        let sut = MovieRepository(MockFailedFetchMovieRequestWithWrongID())
        sut.fetchMovie(id: 1) { result in
            switch(result) {
            case .success(_):
                assertionFailure("The success case should not have been called.")
                break
            case .failure(let error):
                if let error = error as? MovieError {
                    XCTAssertEqual(error, .invalidEndpoint)
                    break
                }
                assertionFailure("Error raised wes not of type Invalid Endpoint")
            }
        }
    }
}

private final class MockSuccessfulFetchMoviesRequest: NetworkRequestProtocol {
    func execute(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let resourceURL = Bundle(for: MovieRepositoryTests.self).url(forResource: "top_rated_movies", withExtension: "json")!
        let data = try! Data(contentsOf: resourceURL)

        completion(.success(data))
    }
}

private final class MockFailedFetchMoviesRequest: NetworkRequestProtocol {
    func execute(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(MovieError.apiError))
    }
}

private final class MockSuccessfulFetchMovieRequest: NetworkRequestProtocol {
    func execute(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let resourceURL = Bundle(for: MovieRepositoryTests.self).url(forResource: "movie", withExtension: "json")!
        let data = try! Data(contentsOf: resourceURL)

        completion(.success(data))
    }
}

private final class MockFailedFetchMovieRequestWithWrongID: NetworkRequestProtocol {
    func execute(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(MovieError.invalidEndpoint))
    }
}
