Offline Creditcard
==================

This extension is intended for stores that need offline creditcard processing.  Orders are automatically authorized after the user submits their payment.  Store owners can then manually process (or use some other automate external process) to actually authorize/capture the credit card.  

Clicking the "capture" link in the admin order listing will also automatically "capture" the order (without any interraction with a gateway.)  This allows for offline capturing (separate from authorizing) if that is desired.  

Note the values of Spree::Config[:store\_cc\_] and Spree::Config[:store\_cvv\_] preferences are ignored since these values need to be stored (in encrypted form) in order to process later.

Requires a public.pem file in your application route for encryption.  (Obviously you'll need the corresponding private key for decryption as well.)