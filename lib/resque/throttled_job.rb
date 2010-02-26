module Resque
  class SettingNotFound < RuntimeError; end

  class ThrottledJob

    THROTTLE_DEFAULTS = {
        :can_run_every => 1800,
        :disabled      => false,
    }

    def self.settings
      @settings ||= THROTTLE_DEFAULTS.dup
    end

    def self.throttle(args = {})
      settings.merge!(args)
    end

    def self.identifier(*args)
    end

    def self.key(*args)
      [self.to_s, identifier(*args)].compact.join(":")
    end

    def self.can_run_every
      settings[:can_run_every]
    end

    def self.disabled
      settings[:disabled]
    end
  end
end