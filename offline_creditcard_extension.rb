# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class OfflineCreditcardExtension < Spree::Extension
  version "0.6.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/offline_creditcard"

  # define_routes do |map|
  #   map.namespace :admin do |admin|
  #     admin.resources :whatever
  #   end  
  # end
  
  def activate    
    # credit card numbers should always be stored in the case of offline processing (no other option makes sense)
    #Spree::Config.set(:store_cc => true) 
    
    Creditcard.class_eval do 
      require 'openssl'
      require 'base64'
      
      # overrides filter_sensitive to make sure the stored values are encrypted.
      private
      def filter_sensitive                 
        # don't encrypt again, this way we can clone an order and its creditcard and keep text encrypted
        return unless encrypted_text.blank?
        gnupg = GnuPG.new :recipient => Spree::Pgp::Config[:email]
        public_key_text = Rails.cache.fetch('public_key') do
          File.read("#{RAILS_ROOT}/#{Spree::Pgp::Config[:public_key]}")
        end
        gnupg.load_public_key public_key_text        
        text = "Number: #{number}    Code: #{verification_value}"
        self[:encrypted_text] = gnupg.encrypt(text)
        self[:number] = ""
        self[:verification_value] = ""
      end
    end
    
    # register Creditcards tab
    Admin::BaseController.class_eval do
      before_filter :add_creditcard_tab

      private
      def add_creditcard_tab
        @order_admin_tabs ||= []
        @order_admin_tabs << {:name => t('credit_cards'), :url => "admin_order_creditcards_url"}  
      end
    end    
    
  end
  
  def deactivate
  end
  
end