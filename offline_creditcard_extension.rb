# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class OfflineCreditcardExtension < Spree::Extension
  version "1.0"
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
    
    CreditcardPayment.class_eval do 
      require 'openssl'
      require 'base64'
      
      # override the number attribute so we can encrypt it before its stored
      def number=(number)
        public_key = cache.fetch('public_key') do
          # TODO - remove hard code of filename
          OpenSSL::PKey::RSA.new(File.read("public.pem"))  
        end
        encrypted_number = Base64.encode64(public_key.public_encrypt(number))        
        self[:number] = encrypted_number
      end
    end
  end
  
  def deactivate
  end
  
end