//
//  CurrencyRepository.swift
//  exchange-rates
//
//  Created by Vladyslav Deba on 13/11/2024.
//

import Foundation

struct CurrencyResponse: Codable {
    let rates: [String: Double]
}

protocol CurrencyRepository {
    func getLatestRates(baseCurrencyCode: String) async throws -> CurrencyResponse
}

final class RemoteCurrencyRepository: CurrencyRepository {
    private let baseURL = "http://data.fixer.io/api/latest"
    
    func getLatestRates(baseCurrencyCode: String) async throws -> CurrencyResponse {
        guard let url = URL(string: "\(baseURL)?base=\(baseCurrencyCode)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(Environment.apiKey, forHTTPHeaderField: "access_key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(CurrencyResponse.self, from: data)
    }
}

final class MockCurrencyRepository: CurrencyRepository {
    func getLatestRates(baseCurrencyCode: String) async throws -> CurrencyResponse {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        guard let jsonData = getMockData() else {
            throw URLError(.cannotDecodeContentData)
        }
        return try JSONDecoder().decode(CurrencyResponse.self, from: jsonData)
    }
}

extension MockCurrencyRepository {
    private func getMockData() -> Data? {
        let string = """
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
        return string.data(using: .utf8)
    }
}
