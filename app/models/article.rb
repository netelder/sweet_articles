class Article < ActiveRecord::Base
  attr_accessible :title, :description, :url
  validates :title, :description, presence: true
  has_and_belongs_to_many :tags
  belongs_to :category
end
