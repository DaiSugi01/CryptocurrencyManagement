# CryptocurrencyManagement
![CryptocurrencyManagement](https://user-images.githubusercontent.com/37020406/106434608-a550c180-6426-11eb-9411-a9f61f3f73ef.gif)

## App description

### Cryptocurrency App
#### Function 1: Display the list of cryptocurrencies of users' choice on the main page.
#### Function 2: The user can add and delete currencies on the list.
#### Function 3: Receive target price alert (under development).
#### Function 4: Detail page showing the chart and the orderbook for each currency.


## How did satisfy all the requirements

### Requirement 1: Multiscreen Application
#### This app has three screens (main page, detail page, add/edit page).

### Requirement 2: API Integration
#### We utilize five APIs (from four organisations).

1. Shrimpy -- Order book
API document : https://developers.shrimpy.io/docs/#get-order-books
APIEndpoint: https://dev-api.shrimpy.io/v1/orderbooks?exchange=bittrex&baseSymbol=BTC&quoteSymbol=usd&limit=10

2. Nomics -- Realtime rate
API document : https://nomics.com/docs/#operation/getCurrenciesTicker
APIEndpoint: https://api.nomics.com/v1/currencies/ticker?key={API_KEY}&ids=BTC,ETH,XRP&interval=1d&convert=CAD&per-page=100&page=1

3. Messari -- Previous rates (for chart)
API document : https://messari.io/api/docs#operation/Get%20all%20Assets%20V2
APIEndpoint: https://data.messari.io/api/v1/assets/{CURRENCY_NAME}/metrics/price/time-series

4. Messari -- Coin name list (for select box)
API document : https://messari.io/api/docs#operation/Get%20all%20Assets%20V2 
APIEndpoint: https://data.messari.io/api/v2/assets

5. Foreign exchange rates API -- Convert USD orderbook prices into CAD
API document : https://exchangeratesapi.io/
APIEndpoint : https://api.exchangeratesapi.io/latest?base=USD



### Requirement 3: TableView Usage
#### TableView is used for listing currencies on the main page.

