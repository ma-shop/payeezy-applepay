@objc(CDVApplePay) class CDVApplePay : CDVPlugin {
    func makePaymentRequest(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )

        self.commandDelegate!.sendPluginResult(
            pluginResult, 
            callbackId: command.callbackId
        )
    }
}