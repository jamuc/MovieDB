//
//  MovieKitTests.swift
//  MovieKitTests
//
//  Created by Jason Franklin on 12.12.20.
//

import XCTest
@testable import MovieKit

class MovieKitTests: XCTestCase {

    // This test case will throw and exception if the coding keys
    // don't match to the API response recording.
    func testJSONDecodingForTopRatedMovies() throws {
        let url = Bundle(for: MovieKitTests.self).url(forResource: "top_rated_movies", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        // will throw exception if I messed up the coding keys
        let response = try! decoder.decode(MoviesResponse.self, from: data)

        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.totalPages, 405)
    }
}
