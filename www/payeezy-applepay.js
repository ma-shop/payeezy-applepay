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
     * @param details - Object 
     **/
    makePaymentRequest: function(successCallback, errorCallback, details) {
        exec(successCallback, errorCallback, 'ApplePay', 'makePaymentRequest', [details]);
    }
};

module.exports = ApplePay;
