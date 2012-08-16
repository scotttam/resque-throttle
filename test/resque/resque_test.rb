require File.dirname(__FILE__) + '/../test_helper'

class ResqueTest < Test::Unit::TestCase

  context "Resque" do
    setup do
      flush_all
      assert_nil Resque.redis.get(OneHourThrottledJob.key)
      @bogus_args = "bogus_arg"
    end

    context "#enqueue" do
      should "add a throttled job key to the set with the proper TTL (Expire)" do
        Resque.expects(:enqueue_without_throttle).returns(true)
        assert Resque.enqueue(IdentifierThrottledJob, @bogus_args)
        assert Resque.redis.keys('*').include?("IdentifierThrottledJob:my_bogus_arg")
        assert_equal 3600, Resque.redis.ttl(IdentifierThrottledJob.key(@bogus_args))
      end
      
      context "job has not reached throttle limit" do
        should "not add another job to the queue and raise a throttled exception" do
          Resque.expects(:enqueue_without_throttle).once
          assert_raises(Resque::ThrottledError) { 2.times { Resque.enqueue(OneHourThrottledJob, @bogus_args) } }
        end

        should "not add another job and not throw an exception if throws exception is false" do
          Resque.expects(:enqueue_without_throttle).once
          assert_raises(Resque::ThrottledError) { 2.times { Resque.enqueue(DefaultThrottledJob, @bogus_args) } }
        end
      end

      should "enqueue a job without throttling if the job is disabled" do
        Resque.expects(:enqueue_without_throttle).twice
        2.times { Resque.enqueue(DisabledThrottledJob, @bogus_args) }
      end

      context "job fails" do
        should "not prevent another job from queuing if the job failed" do
          Resque.expects(:enqueue_without_throttle).twice
          Resque.enqueue(DefaultThrottledJob, @bogus_args)
          DefaultThrottledJob.on_failure(@bogus_args) # Mock the job's failure
          Resque.enqueue(DefaultThrottledJob, @bogus_args)
        end

        should "prevent another job from queuing if reset_on_failure is false" do
          Resque.expects(:enqueue_without_throttle).once
          Resque.enqueue(OneHourThrottledJob, @bogus_args)
          DefaultThrottledJob.on_failure(@bogus_args) # Mock the job's failure
          assert_raises(Resque::ThrottledError) { Resque.enqueue(OneHourThrottledJob, @bogus_args) }
        end
      end
    end
  end

  def flush_all
    Resque.redis.respond_to?(:flushall) ? Resque.redis.flushall : Resque.redis.flush_all
  end
end
