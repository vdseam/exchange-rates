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
                    filterButton
                    
                    Spacer()
                    
                    bottomStatusBar
                    
                    Spacer()
                    
                    baseCurrencyPicker
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
    
    private var filterButton: some View {
        Button {
            viewModel.isFiltered.toggle()
        } label: {
            Image(systemName: viewModel.isFiltered ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
        }
        .buttonStyle(NoTapAnimationStyle())
    }
    
    private var bottomStatusBar: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading || viewModel.updatedAt.isEmpty {
                Text("Loading...")
            } else {
                Text("Updated \(viewModel.updatedAt)")
                
                Text("Base: \(viewModel.baseCurrencyCode)")
                    .foregroundStyle(.secondary)
            }
        }
        .font(.system(size: 12))
    }
    
    private var baseCurrencyPicker: some View {
        Menu {
            let availableBaseCurrencies = ["EUR"]
            Picker(selection: $viewModel.baseCurrencyCode, label: EmptyView()) {
                ForEach(availableBaseCurrencies, id: \.self) {
                    Text($0)
                }
            }
        } label: {
            Button(action: {}) {
                Image(systemName: "ellipsis.circle")
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
