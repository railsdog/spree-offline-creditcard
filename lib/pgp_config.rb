class PgpConfig < Configuration

  preference :email, :string, :default => "foo@example.com" # replace with address of your PGP key
  preference :public_key, :string, :default => "config/foo-public.asc" # replace with real location of PUBLIC key
  
  validates_presence_of :name
  validates_uniqueness_of :name
end