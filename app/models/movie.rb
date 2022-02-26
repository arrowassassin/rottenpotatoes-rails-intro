class Movie < ActiveRecord::Base
    def self.get_unique_ratings
        return self.uniq.pluck(:rating)
    end
end


