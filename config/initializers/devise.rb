# Devise.setup do |config|
#   config.jwt do |jwt|
#     jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
#     jwt.dispatch_requests = [
#       ['POST', %r{ˆ/signin$}],
#     ]
#     jwt.revocation_requets = [
#       ['DELETE', %r{ˆ/signout$}]
#     ]
#     jwt.expiration_time = 14.days.to_i
#     jwt.aud_header = 'JWT_AUD'
#   end
# end
