//
//  LocalCurrencyStorage.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation
import CoreData

protocol CurrencyStorage {
    func saveCurrencies(_ currencies: [Currency])
    func fetchCurrencies() -> [Currency]
    func toggleFavorite(for currencyCode: String)
    func removeAll()
}

final class LocalCurrencyStorage: CurrencyStorage {
    private let context = PersistenceController.shared.context
    
    func saveCurrencies(_ currencies: [Currency]) {
        currencies.forEach { currency in
            updateOrCreateCurrency(currency)
        }
    }
    
    private func updateOrCreateCurrency(_ currency: Currency) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", currency.code)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingCurrency = results.first {
                existingCurrency.index = Int32(currency.index)
                existingCurrency.value = currency.value
            } else {
                let newCurrency = Item(context: context)
                newCurrency.index = Int32(currency.index)
                newCurrency.code = currency.code
                newCurrency.name = currency.name
                newCurrency.symbol = currency.symbol
                newCurrency.value = currency.value
                newCurrency.isFavorite = currency.isFavorite
            }
            try context.save()
            
        } catch {
            print("Failed to update or create currency: \(error)")
        }
    }
    
    func fetchCurrencies() -> [Currency] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest)
            return items.map { item in
                Currency(
                    index: Int(item.index),
                    code: item.code ?? "",
                    name: item.name ?? "",
                    symbol: item.symbol ?? "",
                    value: item.value,
                    isFavorite: item.isFavorite
                )
            }
            .sorted(by: { $0.code < $1.code })
        } catch {
            print("Failed to fetch currencies: \(error)")
            return []
        }
    }
    
    func toggleFavorite(for currencyCode: String) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", currencyCode)
        
        do {
            if let currencyEntity = try context.fetch(fetchRequest).first {
                currencyEntity.isFavorite.toggle()
                try context.save()
            }
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }
    
    func removeAll() {
        let entityNames = PersistenceController.shared.container
            .managedObjectModel.entities.compactMap { $0.name }
        
        entityNames.forEach { [weak self] entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self?.context.execute(deleteRequest)
                try self?.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
