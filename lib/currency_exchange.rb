require './lib/parsers/json_parser'
require 'logger'
load 'data/eurofxref-hist-90d.json'

module CurrencyExchange
  include JsonParser

  BASE_CURRENCY='EUR'

  @logger = Logger.new(STDOUT)
  @data = JsonParser.parse_from_file('data/eurofxref-hist-90d.json')

  # Return the exchange rate between from_currency and to_currency on date as a float.
  # Raises an exception if unable to calculate requested rate.
  # Raises an exception if there is no rate for the date provided.
  def self.rate(date, from_currency, to_currency, data_source = @data, base_currency = BASE_CURRENCY)
    formatted_date, formatted_from_currency, formatted_to_currency =
        self.format_args([date, from_currency, to_currency])

    begin
      rate_from = data_source[formatted_date][formatted_from_currency]
      rate_to = data_source[formatted_date][formatted_to_currency]

      if formatted_to_currency == base_currency
        return (1 / rate_from).to_f
      else
        return (rate_to / rate_from).to_f
      end
    rescue NoMethodError => e
      @logger.error(e)
      raise ArgumentError, 'Unable to calculate the exchange rate for the date provided'
    rescue TypeError => e
      @logger.error(e)
      raise ArgumentError, 'Unable to calculate the exchange rate for the currencies provided'
    rescue ZeroDivisionError => e
      @logger.error(e)
      raise ZeroDivisionError, 'Attempted to divide by zero'
    end
  end

  private
  def self.format_args(args)
    formatted_args = args.map{ |arg| arg.to_s.upcase.strip }
    return formatted_args
  end
end
