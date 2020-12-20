import SwiftUI
import MovieKit

/*
 * Display a scrollable GridView of movies.
 * Loads the movies dependant on the endpoint which
 * is set: see MovieEndpoint
 *
 */
struct MovieListView: View {
    let endpoint: MovieEndpoint
    let columns = [GridItem(), GridItem()]

    @State private var movies = [Movie]()
    @State private var displayAlertMessage = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, content: {
                    ForEach(movies) { movie in
                        MovieView(movie: movie)
                    }
                })
            }
            .padding()
            .navigationBarTitle("\(self.endpoint.description)", displayMode: .inline)
        }
        .onAppear(perform: loadMovies)
        .alert(isPresented: $displayAlertMessage, content: {
            Alert(title: Text("Unable to load '\(self.endpoint.description)' movies"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        })
    }

    func loadMovies() {
        let repository = MovieRepository()
        repository.fetchMovies(from: endpoint) { result in
            switch(result) {
            case .failure(let error):
               handleError(error: error)
            case .success(let response):
                DispatchQueue.main.async {
                    self.movies = response.results
                }
            }
        }
    }

    func handleError(error: Error) {
        if let movieError = error as? MovieError {
            switch(movieError) {
            case .invalidResponse, .apiError, .noData:
                alertMessage = "The Movie DB server is currently not reachable. Pleese, try again later."
            case .invalidEndpoint:
                alertMessage = "Invalid endpoint called: \(self.endpoint.description)"
            case .serializationError:
                alertMessage = "Was not able to interpret data returned from the server."
            }
        } else {
            alertMessage = "\(error)"
        }

        self.displayAlertMessage = true
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(endpoint: .topRated)
    }
}
