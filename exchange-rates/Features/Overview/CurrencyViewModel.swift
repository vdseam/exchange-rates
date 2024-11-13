//
//  CurrencyViewModel.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Combine
import Foundation

class CurrencyViewModel: ObservableObject {
    private let storage: CurrencyStorage
    private let repository: CurrencyRepository
    private var cancellable: Set<AnyCancellable> = []
    
    @Published private(set) var rates: [Currency] = []
    @Published private(set) var isLoading = false
    @Published private(set) var updatedAt = String()
    
    @Published var searchText = String()
    @Published var baseCurrencyCode = UserDefaults.baseCurrencyCode
    @Published var isFiltered = false
    
    private let names: [String: String] = [
        "AED": "United Arab Emirates Dirham",
        "AFN": "Afghan Afghani",
        "ALL": "Albanian Lek",
        "AMD": "Armenian Dram",
        "ANG": "Netherlands Antillean Guilder",
        "AOA": "Angolan Kwanza",
        "ARS": "Argentine Peso",
        "AUD": "Australian Dollar",
        "AWG": "Aruban Florin",
        "AZN": "Azerbaijani Manat",
        "BAM": "Bosnia-Herzegovina Convertible Mark",
        "BBD": "Barbadian Dollar",
        "BDT": "Bangladeshi Taka",
        "BGN": "Bulgarian Lev",
        "BHD": "Bahraini Dinar",
        "BIF": "Burundian Franc",
        "BMD": "Bermudan Dollar",
        "BND": "Brunei Dollar",
        "BOB": "Bolivian Boliviano",
        "BRL": "Brazilian Real",
        "BSD": "Bahamian Dollar",
        "BTC": "Bitcoin",
        "BTN": "Bhutanese Ngultrum",
        "BWP": "Botswanan Pula",
        "BYN": "New Belarusian Ruble",
        "BYR": "Belarusian Ruble",
        "BZD": "Belize Dollar",
        "CAD": "Canadian Dollar",
        "CDF": "Congolese Franc",
        "CHF": "Swiss Franc",
        "CLF": "Chilean Unit of Account (UF)",
        "CLP": "Chilean Peso",
        "CNY": "Chinese Yuan",
        "CNH": "Chinese Yuan Offshore",
        "COP": "Colombian Peso",
        "CRC": "Costa Rican Colón",
        "CUC": "Cuban Convertible Peso",
        "CUP": "Cuban Peso",
        "CVE": "Cape Verdean Escudo",
        "CZK": "Czech Republic Koruna",
        "DJF": "Djiboutian Franc",
        "DKK": "Danish Krone",
        "DOP": "Dominican Peso",
        "DZD": "Algerian Dinar",
        "EGP": "Egyptian Pound",
        "ERN": "Eritrean Nakfa",
        "ETB": "Ethiopian Birr",
        "EUR": "Euro",
        "FJD": "Fijian Dollar",
        "FKP": "Falkland Islands Pound",
        "GBP": "British Pound Sterling",
        "GEL": "Georgian Lari",
        "GGP": "Guernsey Pound",
        "GHS": "Ghanaian Cedi",
        "GIP": "Gibraltar Pound",
        "GMD": "Gambian Dalasi",
        "GNF": "Guinean Franc",
        "GTQ": "Guatemalan Quetzal",
        "GYD": "Guyanaese Dollar",
        "HKD": "Hong Kong Dollar",
        "HNL": "Honduran Lempira",
        "HRK": "Croatian Kuna",
        "HTG": "Haitian Gourde",
        "HUF": "Hungarian Forint",
        "IDR": "Indonesian Rupiah",
        "ILS": "Israeli New Sheqel",
        "IMP": "Manx pound",
        "INR": "Indian Rupee",
        "IQD": "Iraqi Dinar",
        "IRR": "Iranian Rial",
        "ISK": "Icelandic Króna",
        "JEP": "Jersey Pound",
        "JMD": "Jamaican Dollar",
        "JOD": "Jordanian Dinar",
        "JPY": "Japanese Yen",
        "KES": "Kenyan Shilling",
        "KGS": "Kyrgystani Som",
        "KHR": "Cambodian Riel",
        "KMF": "Comorian Franc",
        "KPW": "North Korean Won",
        "KRW": "South Korean Won",
        "KWD": "Kuwaiti Dinar",
        "KYD": "Cayman Islands Dollar",
        "KZT": "Kazakhstani Tenge",
        "LAK": "Laotian Kip",
        "LBP": "Lebanese Pound",
        "LKR": "Sri Lankan Rupee",
        "LRD": "Liberian Dollar",
        "LSL": "Lesotho Loti",
        "LTL": "Lithuanian Litas",
        "LVL": "Latvian Lats",
        "LYD": "Libyan Dinar",
        "MAD": "Moroccan Dirham",
        "MDL": "Moldovan Leu",
        "MGA": "Malagasy Ariary",
        "MKD": "Macedonian Denar",
        "MMK": "Myanma Kyat",
        "MNT": "Mongolian Tugrik",
        "MOP": "Macanese Pataca",
        "MRU": "Mauritanian Ouguiya",
        "MUR": "Mauritian Rupee",
        "MVR": "Maldivian Rufiyaa",
        "MWK": "Malawian Kwacha",
        "MXN": "Mexican Peso",
        "MYR": "Malaysian Ringgit",
        "MZN": "Mozambican Metical",
        "NAD": "Namibian Dollar",
        "NGN": "Nigerian Naira",
        "NIO": "Nicaraguan Córdoba",
        "NOK": "Norwegian Krone",
        "NPR": "Nepalese Rupee",
        "NZD": "New Zealand Dollar",
        "OMR": "Omani Rial",
        "PAB": "Panamanian Balboa",
        "PEN": "Peruvian Nuevo Sol",
        "PGK": "Papua New Guinean Kina",
        "PHP": "Philippine Peso",
        "PKR": "Pakistani Rupee",
        "PLN": "Polish Zloty",
        "PYG": "Paraguayan Guarani",
        "QAR": "Qatari Rial",
        "RON": "Romanian Leu",
        "RSD": "Serbian Dinar",
        "RUB": "Russian Ruble",
        "RWF": "Rwandan Franc",
        "SAR": "Saudi Riyal",
        "SBD": "Solomon Islands Dollar",
        "SCR": "Seychellois Rupee",
        "SDG": "South Sudanese Pound",
        "SEK": "Swedish Krona",
        "SGD": "Singapore Dollar",
        "SHP": "Saint Helena Pound",
        "SLE": "Sierra Leonean Leone",
        "SLL": "Sierra Leonean Leone",
        "SOS": "Somali Shilling",
        "SRD": "Surinamese Dollar",
        "STD": "São Tomé and Príncipe Dobra",
        "SVC": "Salvadoran Colón",
        "SYP": "Syrian Pound",
        "SZL": "Swazi Lilangeni",
        "THB": "Thai Baht",
        "TJS": "Tajikistani Somoni",
        "TMT": "Turkmenistani Manat",
        "TND": "Tunisian Dinar",
        "TOP": "Tongan Paʻanga",
        "TRY": "Turkish Lira",
        "TTD": "Trinidad and Tobago Dollar",
        "TWD": "New Taiwan Dollar",
        "TZS": "Tanzanian Shilling",
        "UAH": "Ukrainian Hryvnia",
        "UGX": "Ugandan Shilling",
        "USD": "United States Dollar",
        "UYU": "Uruguayan Peso",
        "UZS": "Uzbekistan Som",
        "VEF": "Venezuelan Bolívar Fuerte",
        "VES": "Sovereign Bolivar",
        "VND": "Vietnamese Dong",
        "VUV": "Vanuatu Vatu",
        "WST": "Samoan Tala",
        "XAF": "CFA Franc BEAC",
        "XAG": "Silver (troy ounce)",
        "XAU": "Gold (troy ounce)",
        "XCD": "East Caribbean Dollar",
        "XDR": "Special Drawing Rights",
        "XOF": "CFA Franc BCEAO",
        "XPF": "CFP Franc",
        "YER": "Yemeni Rial",
        "ZAR": "South African Rand",
        "ZMK": "Zambian Kwacha (pre-2013)",
        "ZMW": "Zambian Kwacha",
        "ZWL": "Zimbabwean Dollar"
    ]
    
    var searchResults: [Currency] {
        var results = rates
        if isFiltered {
            results = results.filter { $0.isFavorite }
        }
        
        if searchText.isEmpty {
            return results
        } else {
            return results.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    init(storage: CurrencyStorage = LocalCurrencyStorage(), repository: CurrencyRepository = MockCurrencyRepository()) {
        self.storage = storage
        self.repository = repository
        bind()
    }
    
    private func bind() {
        $baseCurrencyCode
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] baseCurrencyCode in
                guard let self else { return }
                UserDefaults.baseCurrencyCode = baseCurrencyCode
                fetchAndCacheRemoteRates()
                print("Fetching remote rates with base \(baseCurrencyCode)")
            }
            .store(in: &cancellable)
    }
    
    func fetch() {
        if let timestamp = UserDefaults.timestamp {
            formatTimestamp(timestamp)
        }
        fetchCachedRates()
        fetchAndCacheRemoteRates()
    }
    
    private func fetchCachedRates() {
        isLoading = true
        let cachedRates = storage.fetchCurrencies()
        if !cachedRates.isEmpty {
            rates = cachedRates
            isLoading = false
        }
    }
    
    private func fetchAndCacheRemoteRates() {
        if rates.isEmpty {
            isLoading = true
        }
        Task { @MainActor in
            do {
                let response = try await repository.getLatestRates(
                    baseCurrencyCode: baseCurrencyCode
                )
                updateAndFormatTimestamp(response.timestamp)
                
                var i = 0
                for (key, value) in response.rates.sorted(by: { $0.key < $1.key }) {
                    updateOrAppendCurrency(code: key, value: value, index: i)
                    i += 1
                }
                storage.saveCurrencies(rates)
            } catch {
                print(error.localizedDescription)
            }
            // TODO: - Show network error when failed
            isLoading = false
        }
    }
    
    private func updateAndFormatTimestamp(_ timestamp: TimeInterval) {
        UserDefaults.timestamp = timestamp
        formatTimestamp(timestamp)
    }
    
    private func formatTimestamp(_ timestamp: TimeInterval) {
        let date = Date(timeIntervalSince1970: timestamp)
        if Calendar.current.isDateInToday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateStyle = DateFormatter.Style.none
            dateFormatter.timeZone = .current
            updatedAt = "at \(dateFormatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            updatedAt = "yesterday"
        } else {
            updatedAt = "a long time ago"
        }
    }
    
    private func updateOrAppendCurrency(code: String, value: Double, index: Int) {
        if let index = rates.firstIndex(where: { $0.code == code }) {
            rates[index].value = value
        } else {
            // TODO: - Optimize the currency symbol provider
            let symbol = CurrencySymbolProvider.currency(for: code)?.shortestSymbol ?? code
            let currency = Currency(
                index: index + 1,
                code: code,
                name: names[code] ?? String(),
                symbol: symbol,
                value: value
            )
            rates.append(currency)
        }
    }
    
    func toggleFavorite(for currency: Currency) {
        rates[currency.index].isFavorite.toggle()
        storage.toggleFavorite(for: currency.code)
    }
}
