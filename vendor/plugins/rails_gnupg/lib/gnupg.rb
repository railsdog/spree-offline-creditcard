########################################
# Author: Michael Cerna 
# Email: mcerna@ahgsoftware.com
# Minimal GnuPG wrapper for ruby/rails
# TODO: error notifications for failures
########################################
class GnuPG
  
  # Override basic options here
  # Defaults:
  # =>  Working directories are all the current directory (a proper gnupg setup can complex, so I won't presume to setup something RAIL-sy for you)
  def initialize(system_options = {}, ubiquitous_options = {})
    @binary = system_options[:binary] || `which gpg`.to_s.strip
    @workdir = system_options[:workdir] || File.join(RAILS_ROOT,'tmp','gnupg')
    @homedir_pub = system_options[:homedir_pub] || File.join(RAILS_ROOT,'tmp','gnupg')
    @homedir_sec = system_options[:homedir_sec] || File.join(RAILS_ROOT,'tmp','gnupg')
    @recipient = system_options[:recipient] || "uid"
    FileUtils.mkdir_p @workdir
  end
  
  # No key loading necessary
  def encrypt(msg,options = {})
    command = "echo '#{msg}' | #{@binary} --no-secmem-warning --no-permission-warning -q --always-trust --homedir #{@homedir_pub} -a -e -r '#{@recipient}'"
    output = `#{command}`
  end 
  
  # Decrypt string with the passphrase (Key must be loaded)
  def decrypt(encoded_message = nil, passphrase = nil)
    # Make sure we have a key and a message (passphrase is optional)
	  return false if !key_loaded? or !encoded_message

    # Store the crypted message as a temporary file (TODO: Use ruby temp files)
	  msg_file = File.join(@workdir,'message')
	  File.open(msg_file,"w+") do |f| f << encoded_message end
	  command = "echo '#{passphrase}' | #{@binary}  --no-secmem-warning -q --batch --passphrase-fd 0 --homedir #{@homedir_sec} -d #{msg_file} 2>/dev/null"
    output = `#{command}`
	  File.unlink msg_file
	  
	  # Post-newlines get tossed around mad-style, lets get rid of em on the way out
	  return output.strip
	end

	def load_public_key(ascii_armored_key_text = nil)
	  load_key(ascii_armored_key_text,'public')
	end
	  
	def load_secret_key(ascii_armored_key_text = nil)
	  load_key(ascii_armored_key_text,'secret')
	end
	
	# Pass in the ascii secret key contents, to load the key into the working directory
	def load_key(ascii_armored_key_text = nil,key_type = 'secret')	  
	  drop_key if key_loaded?
	  return false if !ascii_armored_key_text or ascii_armored_key_text.length == 0
	  msg_file = File.join(@workdir,'key_file')
    File.unlink(msg_file) if File.exist? msg_file
    File.open(msg_file,"w+") do |f| f << ascii_armored_key_text end
    output = `#{@binary} --no-secmem-warning -v --homedir #{key_type == 'secret' ? @homedir_sec : @homedir_pub} --import #{msg_file}`
    File.unlink(msg_file)

    # Check keys
    debug_output = `#{@binary} --no-secmem-warning -q --homedir #{@homedir_sec} --list#{key_type == 'secret' ? '-secret' : ''}-keys`
    return true if /#{@recipient}/i.match(debug_output)
    drop_key and return false    
	end
	
	# Check if the key is loaded
	def secret_key_loaded?
	  key_loaded?('secret')
	end

	def public_key_loaded?
	  key_loaded?('public')
	end
	
	def key_loaded?(key_type = 'secret')
	  File.size?(File.join((key_type == 'secret' ? @homedir_sec : @homedir_pub),"#{key_type == 'secret' ? 'sec' : 'pub'}ring.gpg")) > 0 rescue false
	end
	
	# Drop the secret key when you're done
	def drop_public_key
	  drop_key('public')
	end
	def drop_secret_key
	  drop_key('secret')
	end
	def drop_key(key_type = 'secret')
	  return false if !key_loaded?(key_type)
	  File.unlink(File.join(key_type == 'secret' ? @homedir_sec : @homedir_pub,"#{key_type == 'secret' ? 'sec' : 'pub'}ring.gpg"))
	end
end
