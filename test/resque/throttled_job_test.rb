require 'test_helper.rb'

class ThrottledJobTest < Test::Unit::TestCase

  context "Resque::ThrottledJob" do
    should "instantiate a new Resque::ThrottledJob" do
      assert Resque::ThrottledJob.new(:queue_name, OneHourThrottledJob)
    end

    context "settings" do
      context "#can_run_every" do
        should "return the number of seconds in which to throttle these jobs" do
          assert_equal 3600, OneHourThrottledJob.can_run_every
        end

        should "default to 30 minutes (1800 seconds) if not provided" do
          assert_equal 1800, DefaultThrottledJob.can_run_every
        end
      end

      context "#identifier" do
        should "return an additional key identifier used in storing the key in the redis SET" do
          assert_equal "my_identifier", IdetifierThrottledJob.identifier
        end

        should "return nil if not defined" do
          assert_nil DefaultThrottledJob.identifier
        end
      end

      context "#enqueued" do
        should "have a default message if not overrriden" do
          assert_equal "Your job has been submitted. You will receive an email with a download link shortly.", DefaultThrottledJob.enqueued
        end

        should "be able to be overriden" do
          assert_equal "Yada Yada", OneHourThrottledJob.enqueued
        end
      end

      context "#throttled" do
        should "have a default message if not overrriden" do
          assert_equal "Frequency has been exceeded. Job not submitted. Try again a little later.", DefaultThrottledJob.throttled
        end

        should "be able to be overriden" do
          assert_equal "Yada Yada", OneHourThrottledJob.throttled
        end
      end

      context "#latest" do
        should "have a default message if not overrriden" do
          assert_equal "Download the most recent result", DefaultThrottledJob.latest
        end

        should "be able to be overriden" do
          assert_equal "Yada Yada", OneHourThrottledJob.latest
        end
      end

      context "#disabled" do
        should "not be disabled by default" do
          assert !DefaultThrottledJob.disabled
        end

        should "be able to be overriden" do
          assert DisabledThrottledJob.disabled
        end
      end
    end

    context "#key" do
      should "consist of the class name and the identifier" do
        assert_equal "IdetifierThrottledJob:my_identifier", IdetifierThrottledJob.key
      end

      should "consist of just the class name if the identifier is not provided" do
        assert_equal "DefaultThrottledJob", DefaultThrottledJob.key
      end
    end
  end
end
