require 'test/unit'
require '../../../../config/environment'
######################################
# There isn't much that this plugin can do 
# to ensure that you have gnupg installed and 
# reasonably setup on your box, we'll do what we can!
class GnupgTest < Test::Unit::TestCase
  # Replace this with your real tests.
  #def test_this_plugin
  #  flunk
  #end
  
  # Let my defaults be loaded for testing
  # These aren't my real keys either, o' hackin' friends o' mine
  # I wouldn't be that silly!
  def setup
    @public_key_ascii = "-----BEGIN PGP PUBLIC KEY BLOCK-----
    Version: GnuPG v1.4.6 (Darwin)

    mQGiBEX9qXMRBADmKDvZ24sPLroIQX5a5/jRBsyDuBniOBVi5//w/2mzW+HiH/Ke
    DxoKce5ZaYTpMgDszOVVo6oLAbSLWqVIu6YktM8nl+5b6tTe22d7AhQVXbvfN/JV
    pMJenj+97zbEOGlLAWcqVeSQ7CTDuDXgP8RYdw+OxFkYRx61q7iGQJ4zRwCgowf8
    /yHVrE9p8nlM1grXp9Yqkn0EAM9CQEsxFQbObJgNBwKgvy6NF+WBO5HbZFvRAAJx
    SnnhmE4KCVupSaob3yG/tMyUzyooqXNiySRvpS8xzCK6eF2AVHzjE4qTF1KYVz6b
    JJEKxD446g51czRkZ+eKDzPWttgS36Yhax2SBsGdyv9bh7B2TD2s4e71ldvcWYxl
    Wm9wA/4rErY7Kc25JBk1bgO5aYXscaJHPH8q/3C909xWpWLzf8F/hrF9RaERHITf
    Az4OGrw1luO2DqDYMA3Lhzy2Ooe0MgZIf1sjRJb7r3pRzqWOiVe58EYa3YqYIoJy
    Z7RhPGX6fTJuk3oNPKIr46Kl2UJLmM7wOCiALYg1vPjFB7Pls7QjTWljaGFlbCBD
    ZXJuYSA8Y2VybmE1MTUwQHlhaG9vLmNvbT6IYAQTEQIAIAUCRf2pcwIbIwYLCQgH
    AwIEFQIIAwQWAgMBAh4BAheAAAoJEFPTl/WRYvCLo6MAnA96jbxC9WZxiP520nWv
    EfltpAyZAJ9TxT8o+NHzJ906KOUAtxiM2eq9UrkBDQRF/al1EAQA0uC0ClIE1Ty4
    DyBX/OCVIt0lHEkaNYLxD+FPgQecAQ7WF0kPaeq1a7wetPZYH2Xm7+DmCkDsPmLY
    CfVNOSwzpyXn23e1WLmcnF/EEI2WQiWx4N+lgzj1LhPWqaQ79VKjWLDQTqIFKnjA
    qUPgIAAEdAlVKZidIiKa+mE29+6pK4MAAwUD/jX4hg/nsHGLEKJ8Lurwl9H4OD+j
    vI36o23Z4VuuLB/ZfVyT02rjmL5XHxyUkkb8yUY0JSpHI5UE16zfnD0oj36uerzE
    oK2kSo5UOLbbeBsA8b9Dq3moVjkpPaZeEHvN7sYa4yXYT9xQf0skaTNjzfNY29pJ
    hnwX1CVd3V88IvQSiEkEGBECAAkFAkX9qXUCGwwACgkQU9OX9ZFi8IuLnQCgm6oy
    R5LISHAje4T39O93T7N7A9AAnjeklp7MKG5fu4JwHpRWSTRW38DB
    =662d
    -----END PGP PUBLIC KEY BLOCK-----" 
    @secret_key_ascii = "-----BEGIN PGP PRIVATE KEY BLOCK-----
    Version: GnuPG v1.4.6 (Darwin)

    lQG7BEX9qXMRBADmKDvZ24sPLroIQX5a5/jRBsyDuBniOBVi5//w/2mzW+HiH/Ke
    DxoKce5ZaYTpMgDszOVVo6oLAbSLWqVIu6YktM8nl+5b6tTe22d7AhQVXbvfN/JV
    pMJenj+97zbEOGlLAWcqVeSQ7CTDuDXgP8RYdw+OxFkYRx61q7iGQJ4zRwCgowf8
    /yHVrE9p8nlM1grXp9Yqkn0EAM9CQEsxFQbObJgNBwKgvy6NF+WBO5HbZFvRAAJx
    SnnhmE4KCVupSaob3yG/tMyUzyooqXNiySRvpS8xzCK6eF2AVHzjE4qTF1KYVz6b
    JJEKxD446g51czRkZ+eKDzPWttgS36Yhax2SBsGdyv9bh7B2TD2s4e71ldvcWYxl
    Wm9wA/4rErY7Kc25JBk1bgO5aYXscaJHPH8q/3C909xWpWLzf8F/hrF9RaERHITf
    Az4OGrw1luO2DqDYMA3Lhzy2Ooe0MgZIf1sjRJb7r3pRzqWOiVe58EYa3YqYIoJy
    Z7RhPGX6fTJuk3oNPKIr46Kl2UJLmM7wOCiALYg1vPjFB7PlswAAnA6lJZPDi0Q2
    dy1SulrCi43/MiaFCY+0I01pY2hhZWwgQ2VybmEgPGNlcm5hNTE1MEB5YWhvby5j
    b20+iGAEExECACAFAkX9qXMCGyMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRBT
    05f1kWLwi6OjAJwPeo28QvVmcYj+dtJ1rxH5baQMmQCfU8U/KPjR8yfdOijlALcY
    jNnqvVKdATEERf2pdRAEANLgtApSBNU8uA8gV/zglSLdJRxJGjWC8Q/hT4EHnAEO
    1hdJD2nqtWu8HrT2WB9l5u/g5gpA7D5i2An1TTksM6cl59t3tVi5nJxfxBCNlkIl
    seDfpYM49S4T1qmkO/VSo1iw0E6iBSp4wKlD4CAABHQJVSmYnSIimvphNvfuqSuD
    AAMFA/41+IYP57BxixCifC7q8JfR+Dg/o7yN+qNt2eFbriwf2X1ck9Nq45i+Vx8c
    lJJG/MlGNCUqRyOVBNes35w9KI9+rnq8xKCtpEqOVDi223gbAPG/Q6t5qFY5KT2m
    XhB7ze7GGuMl2E/cUH9LJGkzY83zWNvaSYZ8F9QlXd1fPCL0EgAA9RIi2bn/+twQ
    IawPuoqhvQPOG6VsevbUfhVBrOTd4pESE4hJBBgRAgAJBQJF/al1AhsMAAoJEFPT
    l/WRYvCLi50AoIriAIGCvTL5dsrHBgp3TFNw3oXbAKCTPRlTStckyZ1FRx7YE1hd
    HTnMmg==
    =P58i
    -----END PGP PRIVATE KEY BLOCK-----"
    
    @gnupg = GnuPG.new :recipient=>"Michael Cerna <cerna5150@yahoo.com>"
  end
  
  def test_load_public_key
    @gnupg.load_public_key @public_key_ascii
    assert @gnupg.public_key_loaded?
  end 

  def test_load_secret_key
    @gnupg.load_secret_key @secret_key_ascii
    assert @gnupg.public_key_loaded?
  end
  
  def test_drop_public_key
    @gnupg.load_public_key @public_key_ascii
    assert @gnupg.public_key_loaded?

    @gnupg.drop_public_key
    assert !@gnupg.public_key_loaded?
  end
  
  def test_drop_secret_key
    @gnupg.load_secret_key @secret_key_ascii
    assert @gnupg.secret_key_loaded?

    @gnupg.drop_secret_key
    assert !@gnupg.secret_key_loaded?
  end
  
  def test_crypted_cycle
    @gnupg.load_public_key @public_key_ascii
    @gnupg.load_secret_key @secret_key_ascii
    
    assert @gnupg.public_key_loaded?
    assert @gnupg.secret_key_loaded?
    
    message = "yo homey"
    encrypted_message = @gnupg.encrypt(message)
    decrypted_message = @gnupg.decrypt(encrypted_message,"my passphrase")
    puts "Pre: #{message} #{message.length}"
    #puts "Enc: #{encrypted_message}"
    puts "Dec: #{decrypted_message} #{decrypted_message.length}"
    assert (message == decrypted_message)
  end
  
end
