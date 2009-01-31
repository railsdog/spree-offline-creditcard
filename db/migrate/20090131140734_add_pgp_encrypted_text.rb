class AddPgpEncryptedText < ActiveRecord::Migration
  def self.up
    change_table :creditcards do |t|
      t.text :encrypted_text
    end
  end

  def self.down
    change_table :creditcards do |t|
      t.remove :encrypted_text
    end    
  end
end