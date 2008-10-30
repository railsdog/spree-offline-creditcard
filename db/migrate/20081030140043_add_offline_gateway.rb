class AddOfflineGateway < ActiveRecord::Migration
  def self.up
    gateway = Gateway.create(:name => "Offline Credit Card Gateway",
                             :clazz => "Spree::OfflineGateway",
                             :description => "Intended for offline (or asynchronous) processing of credit cards.",
                             :gateway_options => [])
  end

  def self.down
  end
end