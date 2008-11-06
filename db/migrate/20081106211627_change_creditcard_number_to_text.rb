class ChangeCreditcardNumberToText < ActiveRecord::Migration
  def self.up
    change_column :creditcard_payments, :number, :text
  end

  def self.down
    change_column :creditcard_payments, :number, :string
  end
end