require "test/unit"
require 'lib/albite_date'
include AlbiteDate

class AlbiteDateTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

#  # Fake test
#  def test_fail
#
#    # To change this template use File | Settings | File Templates.
#    fail("Not implemented")
#  end

  def test_date
    dates = [
      '-1000',
      '1000',
      '1987',
      '1987-6',
      '1987-06',
      '1987-06-13',
      '0712-10',
      '-0712-6',
      '-0712-6-07',
      '-0712-06-07'
    ]

    for date in dates
      compare(date, date_from_store(date_to_store(date)), date_to_store(date))
    end
  end

  def compare(original, to_store, from_store)
    puts "---------------"
    puts "Comparing `#{original}` vs. `#{from_store}` (#{to_store})"
    puts "---------------"
    puts
  end
end