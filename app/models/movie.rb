class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def self.similar_directors(dirtr)
  	@movies = Movie.find_all_by_director(dirtr)
  end
end
