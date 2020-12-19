import SwiftUI
import MovieKit

/*
 * Displays movie poster and rating.
 *
 * Initially view is initialised with a placeholder image displaying the
 * photo SFSymbol. Once view appears it attempts to fetch the movie poster
 * from the network, async.
 * Obviously this can go wrong. Didn't see any point to display an alert message
 * to the user here, so I just skip tyring to load the image on error.
 * In this case user will just see the placeholder image.
 */
struct MovieView: View {
    let movie: Movie

    @State private var poster = Image(systemName: "photo")

    var body: some View {
        ZStack {
            poster
                .resizable()
                .background(Color.gray)
                .foregroundColor(Color.white)
                .onAppear(perform: loadPoster)
            RatingView(rating: movie.averagePercentText)
        }
        .frame(width: 160, height: 240)
    }

    func loadPoster() {
        URLSession.shared.dataTask(with: movie.posterURL) { data, response, error in
            if error != nil {
                // do not update image
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                return
            }

            if let imageData = data,
               let uiImage = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.poster = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}

struct MovieView_Previews: PreviewProvider {
    // Note to self: Repetitive code from #MovieKitTest and I'm not sure I like that.
    // For now this seems the simplest solution and since it's test code, I decided
    // to let it go for now.
    static var previews: some View {
        let url = Bundle.main.url(forResource: "movie", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        let movie = try! jsonDecoder.decode(Movie.self, from: jsonData)
        return MovieView(movie: movie)
    }
}
