class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end
  def self.with_ratings(ratings_list)
    if ratings_list.length() > 0
      formatted_ratings_list = ratings_list.map { |rating| rating.upcase }
        Movie.where(rating: formatted_ratings_list)
    else
      Movie.all
    end
  end
end