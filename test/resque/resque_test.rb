require File.dirname(__FILE__) + '/../test_helper'

class ResqueTest < Test::Unit::TestCase

  context "Resque" do
    setup do
      Resque.redis.flush_all
      assert_nil Resque.redis.get(OneHourThrottledJob.key)
      @bogus_args = "bogus_arg"
    end

    context "#enqueue" do
      should "add a throttled job key to the set with the proper TTL (Expire)" do
        Resque.expects(:enqueue_without_throttle).returns(true) 
        assert Resque.enqueue(IdentifierThrottledJob, @bogus_args)
        assert Resque.redis.keys('*').include?("resque:IdentifierThrottledJob:my_bogus_arg")
        assert_equal 3600, Resque.redis.ttl(IdentifierThrottledJob.key(@bogus_args))
      end
      
      context "job has not reached throttle limit" do
        should "not add another job to the queue and raise a throttled exception" do
          Resque.expects(:enqueue_without_throttle).once
          assert_raises(Resque::ThrottledError) { 2.times { Resque.enqueue(OneHourThrottledJob, @bogus_args) } }
        end
      end

      should "enqueue a job without throttling if the job is disabled" do
        Resque.expects(:enqueue_without_throttle).twice
        2.times { Resque.enqueue(DisabledThrottledJob, @bogus_args) }
      end
    end
  end
end