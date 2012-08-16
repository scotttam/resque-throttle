module Resque
  class SettingNotFound < RuntimeError; end
  class ThrottledError < RuntimeError; end

  class ThrottledJob

    THROTTLE_DEFAULTS = {
        :can_run_every => 1800,
        :throws_exception => false,
        :disabled      => false,
        :reset_on_failure => true,
    }
  
    class << self

      def settings
        @settings ||= THROTTLE_DEFAULTS.dup
      end

      def throttle(args = {})
        settings.merge!(args)
      end

      def identifier(*args)
      end

      def key(*args)
        [to_s, identifier(*args)].compact.join(":")
      end

      def can_run_every
        settings[:can_run_every]
      end

      def disabled
        settings[:disabled]
      end

      def throws_exception
        settings[:throws_exception]
      end

      def reset_on_failure
        settings[:reset_on_failure]
      end

      def before_enqueue(*args)
        !should_throttle?(*args) unless throws_exception
      end

      def after_enqueue(*args)
        if throws_exception && should_throttle?(*args)
          raise ThrottledError.new("#{self.class} with key #{args} has exceeded its throttle limit")
        end
      end

      def on_failure(e, *args)
        clear(*args) if reset_on_failure
      end

      private
       
      def should_throttle?(*args)
        return false if disabled
        return true if key_found?(*args)
        set(*args, can_run_every)
        return false
      end

      def key_found?(*args)
        Resque.redis.get(key(*args))
      end

      def set(*args, can_run_every)
        if Resque.redis.respond_to?(:setex)
          Resque.redis.setex(key(*args), can_run_every, true)
        else
          Resque.redis.set(key(*args), true, can_run_every)
        end
      end

      def clear(*args)
        Resque.redis.del(key(*args))
      end
    end
  end
end
