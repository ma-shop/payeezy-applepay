var exec = require('cordova/exec');

var ApplePay = {

    successCallback: function() {
        console.log(arguments);
    },

    failureCallback: function() {
        console.log(arguments);
    },

    /**
     * @method canMakePayments
     * @description - Detect if iPhone supports Apple Pay and if there is a card available.
     * @param successCallback - Function  
     * @param errorCallback - Function  
     **/
    canMakePayments: function(successCallback, errorCallback) {
        exec(successCallback || this.successCallback, errorCallback || this.failureCallback, 'ApplePay', 'canMakePayments');
    },

    /**
     * @method makePaymentRequest
     * @description - Create payment view controller with order details and given API info
     * @param successCallback - Function  
     * @param errorCallback - Function  
     * @param order_items - Array of Objects {
        label
        amount
     }
     * @param config - Object {
        api_key
        api_secret
        country_code
        currency_code
        environment
        merchant_id
        merchant_ref
        merchant_token
        transaction_type
     }
     **/
    makePaymentRequest: function(order_items, config, successCallback, errorCallback) {
        exec(successCallback || this.successCallback, errorCallback || this.failureCallback, 'ApplePay', 'makePaymentRequest', [order_items, config]);
    }
};

module.exports = ApplePay;
