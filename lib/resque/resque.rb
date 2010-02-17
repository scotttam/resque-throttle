require "resque/throttle"

module Resque
  extend self

  # Raised when trying to create a job that is throttled
  class ThrottledError < RuntimeError; end
      
  def enqueue_with_throttle(klass, *args)
    if should_throttle?(klass)
      raise ThrottledError.new("#{klass} with key #{klass.key} has exceeded it's throttle limit")
    end
    enqueue_without_throttle(klass, *args)
  end
  alias_method :enqueue_without_throttle, :enqueue
  alias_method :enqueue, :enqueue_with_throttle

  private
   
  def should_throttle?(klass)
    return false unless throttle_job?(klass)
    
    if redis.get(klass.key)
      return true
    else
      redis.set(klass.key, true, klass.throttle)
      return false
    end
  end

  def throttle_job?(klass)
    klass.ancestors.include?(Resque::ThrottledJob)  
  end
end