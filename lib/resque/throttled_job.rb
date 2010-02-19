module Resque
  class SettingNotFound < RuntimeError; end

  class ThrottledJob

    THROTTLE_DEFAULTS = {
        :can_run_every => 1800,
        :enqueued      => 'Your job has been submitted. You will receive an email with a download link shortly.',
        :throttled     => 'Frequency has been exceeded. Job not submitted. Try again a little later.',
        :latest        => 'Download the most recent result',
        :disabled      => false,
        :identifier    => nil
    }

    def self.settings
      @settings ||= THROTTLE_DEFAULTS.dup
    end

    def self.throttle(args = {})
      settings.merge!(args)
    end

    def self.key
      [self.to_s, identifier].compact.join(":")
    end

    def self.method_missing(method, *args)
      raise SettingNotFound("Could not find the #{method} setting") if !settings.key?(method)
      settings[method]
    end
  end
end