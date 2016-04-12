#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>
#import <PayeezyClient/PayeezyClient.h>

#define kSupportedNetworks8 @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
#define kSupportedNetworks9 @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex, PKPaymentNetworkDiscover]

@interface CDVApplePay: CDVPlugin <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) NSString* paymentCallbackId;
@property (nonatomic) NSMutableArray* summaryItems;

- (void)makePaymentRequest:(CDVInvokedUrlCommand*)command;
- (void)canMakePayments:(CDVInvokedUrlCommand*)command;

@end
