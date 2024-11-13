//
//  ContentView.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 12/11/2024.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @StateObject private var viewModel = CurrencyViewModel()

    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ForEach(0..<12) { _ in
                        RedactedExchangeRateRow()
                    }
                } else if !viewModel.searchResults.isEmpty {
                    ForEach(viewModel.searchResults, id: \.code) { rate in
                        ExchangeRateRow(currency: rate)
                            .swipeActions {
                                Button("Favorite", systemImage: rate.isFavorite ? "star.slash.fill" : "star.fill") {
                                    viewModel.toggleFavorite(for: rate)
                                }
                                .tint(.orange)
                            }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Currencies")
            .refreshable {
                viewModel.fetch()
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    bottomBarItems
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .overlay {
            if viewModel.searchResults.isEmpty, !viewModel.isLoading {
                ContentUnavailableView.search
            }
        }
        .task {
            viewModel.fetch()
        }
    }
    
    private var bottomBarItems: some View {
        HStack {
            Button {
                viewModel.isFiltered.toggle()
            } label: {
                Image(systemName: viewModel.isFiltered ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
            }
            .buttonStyle(NoTapAnimationStyle())
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("Updated at 01:02")
                // TODO: - Update the time when load method is called
                
                Text("Base: \(viewModel.baseCurrencyCode)")
                    .foregroundStyle(.secondary)
            }
            .font(.system(size: 12))
            
            Spacer()
            
            Menu {
                Picker(selection: $viewModel.baseCurrencyCode, label: EmptyView()) {
                    ForEach(viewModel.rates, id: \.code) { rate in
                        Text(rate.code)
                    }
                }
            } label: {
                Button(action: {}) {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
            .foregroundStyle(.blue)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.context)
}
