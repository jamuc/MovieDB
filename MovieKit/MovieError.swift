import Foundation

/*
 * Possible errors that can occur when attempting to load movies from the network
 *
 * apiError - The API raise an exception
 * invalidEndpoint - Attemptes to query an unknown endpoint, see MovieEndpoint for reference
 * invalidResponse - API returned a response, but we don't know what to do with it
 * noData - API call returned, no data in the response
 * serializationError - parsing the JSON response failed
 */
public enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
