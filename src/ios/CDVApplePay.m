#import "CDVApplePay.h"

@implementation CDVApplePay

@synthesize paymentCallbackId;

- (void)canMakePayments:(CDVInvokedUrlCommand*)command
{
    if (&PKPaymentNetworkDiscover != NULL) {
        self.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkDiscover];
    } else {
        self.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    }
    
    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:self.supportedNetworks]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"This device can make payments and has a supported card"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    } else if ([PKPaymentAuthorizationViewController canMakePayments]) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device can make payments but has no supported cards"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    } else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device cannot make payments"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
}

- (void)makePaymentRequest:(CDVInvokedUrlCommand*)command
{
    NSArray *order_items = [command.arguments objectAtIndex:0];
    NSDictionary *config = [command.arguments objectAtIndex:1];
    
    self.paymentCallbackId = command.callbackId;
    self.api_key = [config objectForKey:@"api_key"];
    self.api_secret = [config objectForKey:@"api_secret"];
    self.merchant_token = [config objectForKey:@"merchant_token"];
    self.merchant_ref = [config objectForKey:@"merchant_ref"];
    self.merchant_id = [config objectForKey:@"merchant_id"];
    self.environment = [config objectForKey:@"environment"];
    self.transaction_type = [config objectForKey:@"transaction_type"];
    
    PKPaymentRequest *request = [PKPaymentRequest new];
    
    if (&PKPaymentNetworkDiscover != NULL) {
        self.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkDiscover];
    } else {
        self.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    }
    
    request.paymentSummaryItems = [self parseItems:order_items];
    request.requiredBillingAddressFields = PKAddressFieldAll;
    request.requiredShippingAddressFields = PKAddressFieldNone;
    request.merchantCapabilities = PKMerchantCapability3DS;
    request.merchantIdentifier = self.merchant_id;
    request.countryCode = [config objectForKey:@"country_code"];
    request.currencyCode = [config objectForKey:@"currency_code"];
    request.supportedNetworks = self.supportedNetworks;
    
    PKPaymentAuthorizationViewController *authVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    
    authVC.delegate = self;
    
    if (authVC == nil) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"PKPaymentAuthorizationViewController was nil."];
        [self.commandDelegate sendPluginResult:result callbackId:self.paymentCallbackId];
        return;
    }
    
    [self.viewController presentViewController:authVC animated:YES completion:nil];
}


- (NSMutableArray *)parseItems:(NSArray *)order_items
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in order_items) {
        NSString *label = [item objectForKey:@"label"];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithDecimal:[[item objectForKey:@"amount"] decimalValue]];
        
        PKPaymentSummaryItem *newItem = [PKPaymentSummaryItem summaryItemWithLabel:label amount:amount];
        
        [items addObject:newItem];
    }
    
    return items;
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    PayeezyClient *paymentProcessor = [[PayeezyClient alloc] initWithApiKey:self.api_key
                                                                  apiSecret:self.api_secret
                                                              merchantToken:self.merchant_token
                                                                environment:self.environment ];
    
    [paymentProcessor submit3DSTransactionWithPaymentInfo:payment.token.paymentData
                                          transactionType:self.transaction_type
                                          applicationData:nil
                                       merchantIdentifier:self.merchant_id
                                              merchantRef:self.merchant_ref
                                               completion:^(NSDictionary *response, NSError *error) {
                                                   
                                                   if (error) {
                                                       NSLog(@"%@", [error localizedDescription]);
                                                       CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: [error localizedDescription]];
                                                       
                                                       [self.commandDelegate sendPluginResult:result callbackId:self.paymentCallbackId];
                                                       
                                                       completion(PKPaymentAuthorizationStatusFailure);
                                                   } else {
                                                       NSLog(@"%@", response);
                                                       CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
                                                       
                                                       [self.commandDelegate sendPluginResult:result callbackId:self.paymentCallbackId];
                                                       
                                                       completion(PKPaymentAuthorizationStatusSuccess);
                                                   }
                                               }];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
