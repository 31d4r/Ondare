//
//  RadioStationRow.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 7. 7. 2025..
//

import SwiftUI

private enum Constants {
    static let stationImageSize: CGFloat = 80
    static let cornerRadius: CGFloat = 10
}

struct RadioStationRow: View {
    var imageUrl: String?
    var title: String
    var isFavourite: Bool

    var isPlaying: Bool

    var onToggleFavourite: () -> Void
    var action: (() -> Void)? = nil

    var body: some View {
        radioStationLibraryView()
    }

    func radioStationLibraryView() -> some View {
        VStack {
            HStack {
                let imageURL = imageUrl.flatMap { URL(string: $0) }
                let secureImageURL = secureURL(from: imageURL)

                AsyncImage(url: secureImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: Constants.stationImageSize,
                            height: Constants.stationImageSize
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: Constants.cornerRadius
                            )
                        )
                } placeholder: {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: Constants.stationImageSize,
                            height: Constants.stationImageSize
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: Constants.cornerRadius
                            )
                        )
                }

                if isPlaying {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .fontWeight(.light)
                        .foregroundStyle(.oBlue)
                }

                Text(title)
                    .fontWeight(.light)

                Spacer()

                Button(action: onToggleFavourite) {
                    Image(systemName: isFavourite ? "heart.fill" : "heart")
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(.oBlue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(
                isPlaying ?
                    Color.oBlue.opacity(0.15) :
                    Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}
