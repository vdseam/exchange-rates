//
//  ContentView.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 12/11/2024.
//

import SwiftUI
import CoreData
import Combine

struct ExchangeRate: Identifiable, Codable {
    let id = UUID()
    let currency: String
    let rate: Double
    var isFavorite: Bool = false
}

struct Currency2 {
   let code: String
   let symbols: [String]
    
   var shortestSymbol: String {
      return symbols.min { $0.count < $1.count } ?? ""
   }
   
   static func currency(for code: String) -> Currency2? {
      return cache[code]
   }
   
   static fileprivate var cache: [String: Currency2] = { () -> [String: Currency2] in
      var mapCurrencyCode2Symbols: [String: Set<String>] = [:]
      let currencyCodes = Set(Locale.commonISOCurrencyCodes)
      
      for localeId in Locale.availableIdentifiers {
         let locale = Locale(identifier: localeId)
         guard let currencyCode = locale.currencyCode, let currencySymbol = locale.currencySymbol else {
            continue
         }
         if currencyCode.contains(currencyCode) {
            mapCurrencyCode2Symbols[currencyCode, default: []].insert(currencySymbol)
         }
      }
      
      var mapCurrencyCode2Currency: [String: Currency2] = [:]
      for (code, symbols) in mapCurrencyCode2Symbols {
         mapCurrencyCode2Currency[code] = Currency2(code: code, symbols: Array(symbols))
      }
      return mapCurrencyCode2Currency
   }()
}

class MockCurrencyService {
    func fetchCurrencyRates(completion: @escaping (Result<CurrencyResponse, Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // Parse the mock data into a CurrencyResponse object
            do {
                let jsonData = self.mockData.data(using: .utf8)!
                let response = try JSONDecoder().decode(CurrencyResponse.self, from: jsonData)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private let mockData = """
    {
        "success": true,
        "timestamp": 1731312845,
        "base": "EUR",
        "date": "2024-11-11",
        "rates": {
            "AED": 3.926884,
            "AFN": 73.094033,
            "ALL": 97.936514,
            "AMD": 416.042542,
            "ANG": 1.938285,
            "AOA": 975.574402,
            "ARS": 1062.441701,
            "AUD": 1.624809,
            "AWG": 1.924414,
            "AZN": 1.816556,
            "BAM": 1.950516,
            "BBD": 2.171458,
            "BDT": 128.511851,
            "BGN": 1.95112,
            "BHD": 0.402928,
            "BIF": 3175.257363,
            "BMD": 1.069119,
            "BND": 1.421476,
            "BOB": 7.447684,
            "BRL": 6.150853,
            "BSD": 1.075506,
            "BTC": 1.3140604e-5,
            "BTN": 90.705848,
            "BWP": 14.263625,
            "BYN": 3.519531,
            "BYR": 20954.725901,
            "BZD": 2.167768,
            "CAD": 1.488475,
            "CDF": 3064.094107,
            "CHF": 0.938649,
            "CLF": 0.037376,
            "CLP": 1031.325534,
            "CNY": 7.684399,
            "CNH": 7.611371,
            "COP": 4662.415822,
            "CRC": 550.114839,
            "CUC": 1.069119,
            "CUP": 28.331645,
            "CVE": 109.966064,
            "CZK": 25.27525,
            "DJF": 191.514753,
            "DKK": 7.457746,
            "DOP": 64.765152,
            "DZD": 142.612176,
            "EGP": 52.650995,
            "ERN": 16.03678,
            "ETB": 133.155462,
            "EUR": 1,
            "FJD": 2.409576,
            "FKP": 0.818056,
            "GBP": 0.829021,
            "GEL": 2.907619,
            "GGP": 0.818056,
            "GHS": 17.637055,
            "GIP": 0.818056,
            "GMD": 76.442286,
            "GNF": 9271.143851,
            "GTQ": 8.310881,
            "GYD": 224.996257,
            "HKD": 8.310479,
            "HNL": 27.134997,
            "HRK": 7.365191,
            "HTG": 141.51926,
            "HUF": 408.469079,
            "IDR": 16778.962205,
            "ILS": 3.988497,
            "IMP": 0.818056,
            "INR": 90.219931,
            "IQD": 1408.79663,
            "IRR": 45001.871582,
            "ISK": 148.757215,
            "JEP": 0.818056,
            "JMD": 170.629347,
            "JOD": 0.758223,
            "JPY": 164.352379,
            "KES": 137.916158,
            "KGS": 92.151248,
            "KHR": 4367.250453,
            "KMF": 492.195499,
            "KPW": 962.20656,
            "KRW": 1491.639737,
            "KWD": 0.328284,
            "KYD": 0.896189,
            "KZT": 529.425646,
            "LAK": 23603.497707,
            "LBP": 96307.596318,
            "LKR": 314.643491,
            "LRD": 203.734228,
            "LSL": 18.820466,
            "LTL": 3.156829,
            "LVL": 0.646699,
            "LYD": 5.218959,
            "MAD": 10.62023,
            "MDL": 19.288108,
            "MGA": 4975.613726,
            "MKD": 61.554499,
            "MMK": 3472.455731,
            "MNT": 3632.865265,
            "MOP": 8.611252,
            "MRU": 42.845729,
            "MUR": 49.992201,
            "MVR": 16.517474,
            "MWK": 1864.882763,
            "MXN": 21.604112,
            "MYR": 4.712726,
            "MZN": 68.312905,
            "NAD": 18.820466,
            "NGN": 1820.420139,
            "NIO": 39.573901,
            "NOK": 11.804676,
            "NPR": 145.177418,
            "NZD": 1.793024,
            "OMR": 0.41163,
            "PAB": 1.075466,
            "PEN": 4.033972,
            "PGK": 4.317425,
            "PHP": 62.697925,
            "PKR": 298.643935,
            "PLN": 4.338169,
            "PYG": 8409.375615,
            "QAR": 3.920351,
            "RON": 4.976424,
            "RSD": 117.017236,
            "RUB": 104.854315,
            "RWF": 1474.220004,
            "SAR": 4.015572,
            "SBD": 8.917255,
            "SCR": 14.353019,
            "SDG": 643.087176,
            "SEK": 11.617685,
            "SGD": 1.422516,
            "SHP": 0.818056,
            "SLE": 24.429281,
            "SLL": 22418.880497,
            "SOS": 614.640636,
            "SRD": 37.386836,
            "STD": 22128.597894,
            "SVC": 9.410594,
            "SYP": 2686.193015,
            "SZL": 18.81538,
            "THB": 36.731731,
            "TJS": 11.428359,
            "TMT": 3.752607,
            "TND": 3.338011,
            "TOP": 2.503981,
            "TRY": 36.742509,
            "TTD": 7.308338,
            "TWD": 34.567276,
            "TZS": 2857.189667,
            "UAH": 44.398651,
            "UGX": 3936.299419,
            "USD": 1.069119,
            "UYU": 44.91425,
            "UZS": 13751.873656,
            "VEF": 3872938.541799,
            "VES": 47.759256,
            "VND": 27051.375107,
            "VUV": 126.927948,
            "WST": 2.994798,
            "XAF": 654.196964,
            "XAG": 0.031694,
            "XAU": 0.000393,
            "XCD": 2.889347,
            "XDR": 0.806331,
            "XOF": 654.196964,
            "XPF": 119.331742,
            "YER": 267.092591,
            "ZAR": 18.834503,
            "ZMK": 9623.356745,
            "ZMW": 29.279228,
            "ZWL": 344.255775
        }
    }
    """
}

struct CurrencyResponse: Codable {
    let rates: [String: Double]
}

struct ExchangeRateRow: View {
    let symbol: String
    let description: String
    let value: Double
    let index: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(description)
                    .font(.headline)
                
                HStack(spacing: 6) {
                    Text("\(index)")
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(.primary.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 6))
                    
                    Text(symbol)
                        .foregroundStyle(.secondary)
                }
                .font(.system(size: 14, weight: .medium))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(String(format: "%@%.2f", Currency2.currency(for: symbol)?.shortestSymbol ?? symbol, value))
                    .font(.headline)
                
                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)
                    .font(.system(size: 14, weight: .medium))
                    .opacity(Bool.random() ? 0 : 1)
            }
        }
    }
}

struct MockExchangeRateRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("United States Dollar")
                    .font(.headline)
                    .redacted(reason: .placeholder)
                
                Spacer()
                
                Text("ALL00.00")
                    .font(.headline)
                    .redacted(reason: .placeholder)
            }
            
            HStack(spacing: 6) {
                Text("\(0)")
                    .redacted(reason: .placeholder)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(.primary.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 6))
                
                Text("USD")
                    .foregroundStyle(.secondary)
                    .redacted(reason: .placeholder)
            }
            .font(.system(size: 14, weight: .medium))
        }
    }
}

struct ContentView: View {
    @State private var rates: [String: Double] = [:]
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var isFiltered = false
    
    private let symbols: [String: String] = [
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
    
    var searchResults: [String: Double] {
        // TODO: - Optimize the search by both title and code
        if searchText.isEmpty {
            return rates
        } else {
            return rates.filter { $0.key.contains(searchText) }
        }
    }
    
    @State private var isLoading = true
    @State private var selection = String()

    var body: some View {
        NavigationView {
            List {
                Section {
                    // TODO: - Show the empty view description if couldn't load anything on the timeout.
                    if isLoading, searchResults.isEmpty {
                        ForEach(0..<12) { _ in
                            MockExchangeRateRow()
                        }
                    } else {
                        ForEach(searchResults.sorted(by: <), id: \.key) { key, value in
                            ExchangeRateRow(symbol: key, description: symbols[key] ?? "", value: value, index: 0) // TODO: - Make it enumerated after the loading, so that we keep the indices when filtering
                                .swipeActions {
                                    Button("Favorite", systemImage: "star.fill") { // star.slash.fill
                                        // TODO: - Toggle the icon
                                    }
                                    .tint(.orange)
                                }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Currencies")
            .refreshable {
                load()
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        withAnimation {
                            isFiltered.toggle()
                            // TODO: - Filter favourites
                        }
                    } label: {
                        Image(systemName: isFiltered ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                    .transition(.opacity)
                    .buttonStyle(NoTapAnimationStyle())
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("Updated at 01:02")
                        // TODO: - Update the time when load method is called
                        
                        // TODO: - Bind to the selected base currency
                        Text("Base: EUR")
                            .foregroundStyle(.secondary)
                    }
                    .font(.system(size: 12))
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $selection, label: EmptyView()) {
                            // TODO: - Replace contents with base currencies
                            ForEach(0..<10) {
                                Text("\($0)")
                            }
                        }
                    } label: {
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .task {
            load()
        }
    }
    
    private func load() {
        isLoading = true
        let service = MockCurrencyService()
        service.fetchCurrencyRates { result in
            switch result {
            case .success(let response):
                self.rates = response.rates
                print(response.rates.debugDescription)
                isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
                isLoading = false
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
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
