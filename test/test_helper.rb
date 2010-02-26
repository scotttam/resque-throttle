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
  throttle :can_run_every => 3600

  def self.perform(some_id, some_other_thing)
  end
end

class IdentifierThrottledJob < Resque::ThrottledJob
  @queue = :some_queue

  throttle :can_run_every => 3600

  def self.perform(some_id, some_other_thing)
  end
  
  def self.identifier(*args)
    first, second = *args
    "my_#{first}"
  end
end

class DisabledThrottledJob < Resque::ThrottledJob
  @queue = :some_queue
  throttle :disabled => true

  def self.perform(some_id, some_other_thing)
  end
end
