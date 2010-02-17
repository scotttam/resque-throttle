require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'resque/resque'
require 'resque/throttle'
require 'resque/throttled_job'

class Test::Unit::TestCase
end

#fixture classes
class DefaultThrottledJob < Resque::ThrottledJob
  @queue = :some_queue
  
  def self.perform(some_id, some_other_thing)
  end
end

class OneHourThrottledJob < Resque::ThrottledJob
  @queue = :some_queue

  def self.throttle
    3600
  end
  
  def self.perform(some_id, some_other_thing)
  end
end

class IdetifierThrottledJob < Resque::ThrottledJob
  @queue = :some_queue

  def self.identifier
    "my_identifier"
  end
  
  def self.perform(some_id, some_other_thing)
  end
end
