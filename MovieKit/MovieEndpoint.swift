import Foundation

/*
 * Supported movie endpoints
 */
public enum MovieEndpoint: String, CustomStringConvertible, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case popular
    case topRated = "top_rated"

    public var description: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .upcoming:
            return "Upcoming"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        }
    }
}
