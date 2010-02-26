require "resque/throttle"

module Resque
  extend self

  # Raised when trying to create a job that is throttled
  class ThrottledError < RuntimeError; end
      
  def enqueue_with_throttle(klass, *args)
    if should_throttle?(klass, *args)
      raise ThrottledError.new("#{klass} with key #{klass.key(*args)} has exceeded it's throttle limit")
    end
    enqueue_without_throttle(klass, *args)
  end
  alias_method :enqueue_without_throttle, :enqueue
  alias_method :enqueue, :enqueue_with_throttle

  private
   
  def should_throttle?(klass, *args)
    return false if !throttle_job?(klass) || klass.disabled
    return true if key_found?(klass, *args)
    redis.set(klass.key(*args), true, klass.can_run_every)
    return false
  end

  def key_found?(klass, *args)
     redis.get(klass.key(*args))
  end

  def throttle_job?(klass)
    klass.ancestors.include?(Resque::ThrottledJob)  
  end
end