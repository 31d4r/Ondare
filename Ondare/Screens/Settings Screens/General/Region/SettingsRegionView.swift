//
//  SettingsRegionView.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import SwiftUI

struct SettingsRegionView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        content()
            .navigationBarBackButtonHidden()
            .searchable(
                text: viewModel.binding(for: \.countrySearchText),
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onChange(of: viewModel.state.countrySearchText) { _ in
                viewModel.send(.searchCountry(text: viewModel.state.countrySearchText))
            }
            .task {
                viewModel.send(.fetchStationCountries)
            }
            .alert(
                viewModel.state.regionAlertText,
                isPresented: viewModel.binding(for: \.didUserSelectRegion)
            ) {
                Button {
                    viewModel.onBackButtonTapped()
                } label: {
                    Text("OK")
                }
            }
    }

    func content() -> some View {
        ScrollView {
            radioStationCountriesListView()
        }
    }

    func radioStationCountriesListView() -> some View {
        ForEach(viewModel.state.filteredStationCountries) { country in
            radioStationCountryListRowView(
                name: country.name,
                isSelected: DatabaseManager.shared.isRegionSelected(isoCode: country.iso3166_1)
            ) {
                viewModel.send(.toggleRegionSelection(country: country))
            }
        }
    }

    func radioStationCountryListRowView(
        name: String,
        isSelected: Bool,
        action: (() -> Void)?
    ) -> some View {
        VStack {
            HStack {
                Text(name)
                    .fontWeight(.light)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                }
            }

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
