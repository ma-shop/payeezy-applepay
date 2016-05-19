# Cordova Plugin - payeezy-applepay

## Installation

- cordova plugin add https://github.com/MarketAmericaMobile/payeezy-applepay --save

## Support

## Methods

- canMakePayments
- makePaymentRequest

## Example

cordova.plugins.ApplePay.canMakePayments();

cordova.plugins.ApplePay.makePaymentRequest([{
    label: 'item',
    amount: 0.01
}, {
    label: 'total',
    amount: 0.01
}], {
    api_key: "alknk2jb34kj2b3lk4jbkjsbf;",
    api_secret: "adee123abc13ba41cabc41bc34cba1c34bca123bc",
    country_code: "US",
    currency_code: "USD",
    environment: "CERT",
    merchant_id: "merchant.com.company.test.identifier",
    merchant_ref: "Company Name",
    merchant_token: "fdoa-1ab34ac1234c1b23b4c1b34a1bc3cb11c34bc1b34a",
    transaction_type: "authorize"
});