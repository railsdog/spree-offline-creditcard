class CreditcardPresenter < ActivePresenter::Base
  presents :creditcard, :address
end