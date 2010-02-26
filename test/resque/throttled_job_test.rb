require File.dirname(__FILE__) + '/../test_helper'

class ThrottledJobTest < Test::Unit::TestCase

  context "Resque::ThrottledJob" do
    should "instantiate a new Resque::ThrottledJob" do
      assert Resque::ThrottledJob.new
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
          assert_equal "my_identifier", IdentifierThrottledJob.identifier("identifier")
        end

        should "return nil if not defined" do
          assert_nil DefaultThrottledJob.identifier
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
        assert_equal "IdentifierThrottledJob:my_identifier", IdentifierThrottledJob.key("identifier")
      end

      should "consist of just the class name if the identifier is not provided" do
        assert_equal "DefaultThrottledJob", DefaultThrottledJob.key
      end
    end
  end
end
