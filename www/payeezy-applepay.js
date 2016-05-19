var exec = require('cordova/exec');

var ApplePay = {

    /**
     * @method canMakePayments
     * @description - Detect if iPhone supports Apple Pay and if there is a card available.
     * @param successCallback - Function  
     * @param errorCallback - Function  
     **/
    canMakePayments: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'ApplePay', 'canMakePayments');
    },

    /**
     * @method makePaymentRequest
     * @description - Create payment view controller with order details and given API info
     * @param successCallback - Function  
     * @param errorCallback - Function  
     * @param order_details - Object {
        label
        amount
     }
     * @param merchant_info - Object {
        api_key
        api_secret
        merchant_token
        merchant_ref
        merchant_id
        environment
     }
     **/
    makePaymentRequest: function(successCallback, errorCallback, order_details, merchant_info) {
        exec(successCallback, errorCallback, 'ApplePay', 'makePaymentRequest', [order_details, merchant_info]);
    }
};

module.exports = ApplePay;
