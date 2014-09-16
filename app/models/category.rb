class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :tasks
  validates_presence_of :name
end