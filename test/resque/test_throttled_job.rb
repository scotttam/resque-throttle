require 'test_helper.rb'

class TestThrottledJob < Test::Unit::TestCase
 
  context "Resque::ThrottledJob" do 
    should "instantiate a new Resque::ThrottledJob" do
      assert Resque::ThrottledJob.new("queue_name", "payload")
    end
  end
end
