import Foundation

/*
 * MoviesResponse
 *
 * Top-level response from 'The Movies DB' API
 * Contains meta-information on how many pages there are
 * in the result set and how many of those pages have been loaded.
 * Holds pointer for which page is currently being displayed and a reference
 * to the list of movies returned.
 *
 * Part of the pubic API of this framework
 */
public struct MoviesResponse: Codable {
    public let page: Int // Current page
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Movie]
}

/*
 * Stores all the information of a specific Movie object
 */
public struct Movie: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let backdropPath: String
    public let posterPath: String
    public let overview: String
    public let releaseDate: Date
    public let voteAverage: Double
    public let voteCount: Int
    public let tagline: String?
    public let genres: [MovieGenre]?
    public let videos: MovieVideoResponse?
    public let credits: MovieCreditResponse?
    public let adult: Bool
    public let runtime: Int?

    public var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")!
    }

    public var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }

    public var averagePercentText: String {
        return "\(Int(voteAverage * 10))%"
    }
}

/*
 * Encodes movie genre as a String
 */
public struct MovieGenre: Codable {
    let name: String
}

/*
 * Collection of video responses to the movie
 */
public struct MovieVideoResponse: Codable {
    public let results: [MovieVideo]
}

/*
 * Cast and crew members that helped make the movie
 */
public struct MovieCreditResponse: Codable {
    public let cast: [MovieCast]
    public let crew: [MovieCrew]
}

/*
 * Video responses to the movie on YouTube
 */
public struct MovieVideo: Codable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let size: Int
    public let type: String

    public var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }

        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

/*
 * Name of the character and name of the person playing the character
 */
public struct MovieCast: Codable {
    public let character: String
    public let name: String
}

/*
 * Crew members that worked on the movie
 */
public struct MovieCrew: Codable {
    public let id: Int
    public let department: String
    public let job: String
    public let name: String
}
