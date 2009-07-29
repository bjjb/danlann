# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_grianghraf_session',
  :secret      => 'f37b8da2e3ffca863dcf71a89eee3390da8ea4aad728c5d0ac1579e5732b7235908b03f2563618224ef1b6fda391397f2930fce44e841598dc222f4912cee5a5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
