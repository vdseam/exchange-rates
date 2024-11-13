# Exchange Rates

## Overview
This is a simple iOS application developed using **Swift** to display currency exchange rates. The app allows users to view a list of exchange rates, add specific rates to their favorites, and access previously viewed and favorited rates offline. The application is built using **SwiftUI**, **Combine**, and **CoreData** for managing offline data.

## Features
- A list of currency exchange rates fetched from the **Fixer API**.
- Users can mark specific rates as favorites.
- Offline access to previously viewed and favorited rates using **CoreData**.
- Search functionality by currency code and name.
- Swipe actions to add/remove currencies to/from favorites (native Apple's approach).
- **Responsive UI**: The app adapts well to different screen sizes.
- **Skeleton rows** displayed when there is no data available for offline mode.

## Technical Description

### Architecture & Design
The app is built using the **MVVM (Model-View-ViewModel)** design pattern. This architecture ensures clear separation of concerns:
- **Model**: Represents the currency data and data-fetching logic.
- **View**: The SwiftUI views display the data.
- **ViewModel**: Contains business logic and prepares data for the view.

The app uses **Combine** for reactive programming to handle data updates and bindings between the model and view. 

### App Structure
The app follows the following folder structure:

1. **Application** folder: Contains the root `WindowScene` file.
2. **Common** folder:
    - **Extensions**: Contains helper extensions for various utilities.
    - **Models**:
        - **Response**: Contains response models for parsing API data.
        - **Currency**: Models specific to currency data and handling.
    - **Repositories**:
        - **MockCurrencyRepository**: Mock implementation of currency data fetching (for testing purposes).
        - **RemoteCurrencyRepository**: Responsible for making remote API calls to fetch live currency data.
    - **Utilities**:
        - **CurrencySymbolProvider**: Provides currency symbols based on the currency code.
        - **Environment**: Contains API key configuration and environment setup.
        - **LocalCurrencyStorage**: Manages CoreData storage for offline mode.
3. **Features** folder:
    - **Overview**:
        - **ContentView**: The main view that displays the list of currencies.
        - **CurrencyViewModel**: The view model that manages data for `ContentView`.
        - **ExchangeRateRow**: Represents each row in the list of exchange rates.
4. **Resources** folder:
    - Includes assets, API key configuration, etc.

### Offline Mode Implementation
Offline mode is supported as follows:
- When the app is launched, we first check if there is any data in **CoreData**. If there is, we display the locally stored exchange rates.
- If there is no data in CoreData, **skeleton rows** are shown to indicate that data is loading.
- After displaying the offline data (if available), the app makes an API request to fetch the updated exchange rates.
- The updated rates are then cached into CoreData and will be used for subsequent launches, allowing the app to display the latest exchange rates even without an internet connection.

### API Key Storage
API keys are securely stored using a bash file that is read into the config files once the project builds or runs. This bash file is added to `.gitignore` to prevent it from being pushed to the repository. The approach involves using run scripts for the build schemes, ensuring that API keys are securely managed during development without exposing them in the repository.

### Libraries & Tools Used
- **Swift**: The programming language used to develop the app.
- **SwiftUI**: For building the UI.
- **Combine**: For handling data flow and bindings.
- **CoreData**: For offline storage of favorited rates.
- **URLSession**: For network requests to fetch currency exchange rates from the **Fixer API**.
- **Fixer API**: For getting live currency exchange rates.

### Swipe Actions for Favoriting Currencies
The app uses native **swipe actions** to allow users to add or remove currencies from their favorites list. This provides a seamless and intuitive user experience.

### Unit Tests
Unit tests have been written for the following components:
- **CurrencySymbolProvider**: Ensures the correct symbol is provided for different currencies.
- **MockCurrencyRepository**: Tests the behavior of the mock repository, particularly for fetching mock currency data.

## Additional Features
While the following features were considered, they were not implemented due to limitations in the **Fixer API’s** free plan (which restricts the number of requests to 100 per month):
1. **Base Currency Switch**: The idea behind this feature is to allow the user to select a base currency, with the exchange rates being calculated in relation to that selected base. For example, if a user selects USD as the base currency, all other exchange rates would be displayed as how much of another currency equals 1 USD.
2. **Historical Rates with Graphs**: Historical exchange rates for a selected currency pair, similar to what is seen in Apple Stocks. Users would be able to track how exchange rates have changed over time, helping them make informed decisions.
3. **Two-Way Currency Converter**: A two-way converter would allow users to convert between two currencies in both directions. For example, if a user wants to convert USD to EUR, they would input the amount in USD, and the app would return the equivalent in EUR.

## Demo
https://github.com/user-attachments/assets/6e4446ea-7668-4c61-b3fe-8ca7573df8a8

