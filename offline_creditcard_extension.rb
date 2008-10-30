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
    # admin.tabs.add "Offline Creditcard", "/admin/offline_creditcard", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Offline Creditcard"
  end
  
end