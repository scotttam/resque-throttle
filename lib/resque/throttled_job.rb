module Resque
  class ThrottledJob < Job
    
    def self.identifier
      nil
    end
    
    def self.throttle
      1800
    end
    
    def self.key
      [self.to_s, identifier].compact.join(":")
    end
  end
end