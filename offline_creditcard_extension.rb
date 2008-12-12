# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class OfflineCreditcardExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/offline_creditcard"
  
  def activate    

    Creditcard.class_eval do
      require 'openssl'
      require 'base64'
      
      private

      # overrides filter_sensitive to make sure the stored values are encrypted.
      def filter_sensitive
        public_key_text = Rails.cache.fetch('public_key') do
          OpenSSL::PKey::RSA.new(File.read("public.pem")).to_s
        end
        public_key = OpenSSL::PKey::RSA.new(public_key_text)
        encrypted_number = Base64.encode64(public_key.public_encrypt(number)).gsub("\n","")
        encrypted_cvv = Base64.encode64(public_key.public_encrypt(verification_value)).gsub("\n","")
        self[:number] = encrypted_number
        self[:verification_value] = encrypted_cvv
      end
    end

  end
  
  def deactivate
  end
  
end