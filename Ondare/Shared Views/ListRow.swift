//
//  ListRow.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI

private enum Constants {
    static let systemImageSize: CGFloat = 20
}

struct ListRow: View {
    var title: String
    var trailingText: String?
    var systemImageName: String?

    var showTrailingChevron = false
    var action: (() -> Void)? = nil

    var body: some View {
        VStack {
            HStack {
                if let systemImageName {
                    Image(systemName: systemImageName)
                        .frame(width: Constants.systemImageSize)
                }

                Text(title)

                Spacer()

                if let trailingText {
                    Text(verbatim: trailingText)
                }

                if showTrailingChevron {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.trailing, 5)

            Rectangle()
                .foregroundStyle(.gray.opacity(0.5))
                .frame(height: 1)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
    }
}
