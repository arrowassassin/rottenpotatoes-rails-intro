# class Movie < ActiveRecord::Base
#     def self.get_unique_ratings
#         return self.uniq.pluck(:rating)
#     end
# end


class Movie < ActiveRecord::Base

	def self.all_ratings
		#	['G','PG','PG-13','R']
		@@ratings = self.uniq.pluck(:rating)
		@@ratings	
	end

	def self.with_ratings(ratings_list)
		filtered_movies = nil
		if ratings_list == nil
			filtered_movies = self.all
		else
			filtered_movies = self.where(rating: ratings_list)
		end
		filtered_movies
	end
end