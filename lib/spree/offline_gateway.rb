# Offline gateway that always succeeds in capturing or authorizing the order.  Orders should then be manually 
# authorized/captured or done so by a seperate automated process.

module Spree #:nodoc:
  class OfflineGateway
    
    def initialize(options = {})
    end
    
    def authorize(money, creditcard, options = {})
      ActiveMerchant::Billing::Response.new(true, "Offline Gateway: Forced success", {})
    end

    def purchase(money, creditcard, options = {})
      ActiveMerchant::Billing::Response.new(true, "Offline Gateway: Forced success", {})
    end 

    def credit(money, ident, options = {})
      ActiveMerchant::Billing::Response.new(true, "Offline Gateway: Forced success", {})
    end
 
    def capture(money, ident, options = {})
      ActiveMerchant::Billing::Response.new(true, "Offline Gateway: Forced success", {})
    end
    
    def void(ident, options = {})
      ActiveMerchant::Billing::Response.new(true, "Offline Gateway: Forced success", {})
    end
    
  end
end
