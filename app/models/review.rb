require_relative './concerns/slugifiable.rb'

class Review < ActiveRecord::Base
    belongs_to :user
    has_many :review_genres
    has_many :genres, through: :review_genres

    include Slugifiable::SlugMethod
    extend Slugifiable::FindBySlug
end