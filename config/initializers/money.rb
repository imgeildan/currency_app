require 'money/bank/currencylayer_bank'
mclb = Money::Bank::CurrencylayerBank.new
mclb.access_key = '77be030543cbf4d5f6303e84cf9a3a4a'

# (optional)
# Set the base currency for all rates. By default, USD is used.
# CurrencylayerBank only allows USD as base currency for the free plan users.
mclb.source = 'EUR'

# (optional)
# Set the seconds after than the current rates are automatically expired.
# # By default, they never expire, in this example 1 day.
mclb.ttl_in_seconds = 86400

# mclb.cache = 'tmp/cache'

# Update rates (get new rates from remote if expired or access rates from cache).
# Be sure to define the cache first before updating the rates.
# mclb.update_rates

# Force update rates from remote and store in cache.
# Be sure to define the cache first before updating the rates.
# mclb.update_rates(true)

# Set money rounding mode.
# Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN

# Set money default bank to Currencylayer bank.
Money.default_bank = mclb
