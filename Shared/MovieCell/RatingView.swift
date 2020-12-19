import SwiftUI

/*
 * Show movie rating in top right corner.
 * Uses VStack, HStack and Spacers to squish the text into
 * the top right corner.
 */
struct RatingView: View {
    let rating: String

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(rating)
                    .padding(.all, 10)
                    .background(Color.white)
            }
            Spacer()
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: "45%")
    }
}
