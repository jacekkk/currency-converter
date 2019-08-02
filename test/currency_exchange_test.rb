# These are just suggested definitions to get you started.  Please feel
# free to make any changes at all as you see fit.


# http://test-unit.github.io/
require 'test/unit'
require 'currency_exchange'
require 'date'
require 'json'

class CurrencyExchangeTest < Test::Unit::TestCase
  def setup
  end

  def test_non_base_currency_exchange_is_correct
    correct_rate = 1.2870493690602498
    assert_equal correct_rate, CurrencyExchange.rate(Date.new(2018,11,22), 'GBP', 'USD')
  end

  def test_base_currency_exchange_is_correct
    correct_rate = 0.007763975155279502
    assert_equal correct_rate, CurrencyExchange.rate(Date.new(2018,11,22), 'JPY', 'EUR')
  end

  def test_can_calculate_exchange_rate_for_date_in_string_format
    correct_rate = 1.1286936499695253
    assert_equal correct_rate, CurrencyExchange.rate('2018-11-22', 'GBP', 'EUR')
  end

  def test_can_calculate_exchange_rate_for_currencies_written_in_lowercase
    correct_rate = 13.893823830341365
    assert_equal correct_rate, CurrencyExchange.rate(Date.new(2018,11,22), 'pln', 'php')
  end

  def test_can_calculate_exchange_rate_for_input_with_leading_and_trailing_whitespaces
    correct_rate = 13.893823830341365
    assert_equal correct_rate, CurrencyExchange.rate(' 2018-11-22', 'pln ', ' php ')
  end

  def test_raises_exception_if_date_is_invalid
    invalid_date = 'not a date'
    e = assert_raises ArgumentError do
      CurrencyExchange.rate(invalid_date, 'GBP', 'USD')
    end
    assert_equal 'Unable to calculate the exchange rate for the date provided', e.message
  end

  def test_raises_exception_if_from_currency_is_set_to_base_currency
    e = assert_raises ArgumentError do
      CurrencyExchange.rate(Date.new(2018,11,22), 'EUR', 'GBP')
    end
    assert_equal 'Unable to calculate the exchange rate for the currencies provided', e.message
  end

  def test_raises_exception_if_one_of_the_currencies_is_invalid
    invalid_currency = 'not a currency'
    e = assert_raises ArgumentError do
      CurrencyExchange.rate(Date.new(2018,11,22), invalid_currency, 'USD')
    end
    assert_equal 'Unable to calculate the exchange rate for the currencies provided', e.message
  end

  def test_raises_exception_if_from_currency_equals_zero
    data = {
        '2018-11-22': {
        'USD': 0,
        'GBP': 1
        }
    }

    parsed_data = JSON.parse(data.to_json)

    e = assert_raises ZeroDivisionError do
      CurrencyExchange.rate(Date.new(2018,11,22), 'USD', 'GBP', parsed_data)
    end
    assert_equal 'Attempted to divide by zero', e.message
  end
end
