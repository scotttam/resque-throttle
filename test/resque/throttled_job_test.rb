require 'test_helper.rb'

class ThrottledJobTest < Test::Unit::TestCase
 
  context "Resque::ThrottledJob" do 
    should "instantiate a new Resque::ThrottledJob" do
      assert Resque::ThrottledJob.new(:queue_name, OneHourThrottledJob)
    end
  
    context "#throttle" do
       should "return the number of seconds in which to throttle these jobs" do
         assert_equal 3600, OneHourThrottledJob.throttle
       end
       
       should "default to 30 minutes (1800 seconds) if not provided" do
         assert_equal 1800, DefaultThrottledJob.throttle
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
