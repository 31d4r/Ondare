//
//  SettingsView.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        content()
            .padding(.horizontal)
    }

    func content() -> some View {
        ScrollView {
            Section {
                ListRow(
                    title: "Region",
                    systemImageName: "globe",
                    showTrailingChevron: true
                ) {
                    viewModel.send(.onSettingsRegionTapped)
                }

                Text("Filtering by region shows stations from that country. Leave empty to browse all.")
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray))
                    .padding(.bottom, 10)

            } header: {
                sectionHeaderView(header: "General")
            }

            Section {
                ListRow(
                    title: "Rate Ondare",
                    systemImageName: "star"
                ) {
                    viewModel.send(.onRateOndareAppTapped)
                }
            } header: {
                sectionHeaderView(header: "Extras")
            }
        }
    }

    func sectionHeaderView(header: String) -> some View {
        HStack {
            Text(header)
                .textCase(.uppercase)

            Spacer()
        }
        .foregroundStyle(Color(.systemGray))
    }
}
