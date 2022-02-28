# frozen_string_literal: true

class Program < ApplicationRecord
  has_one_attached :image
  has_many :characters
  has_one :genre

  validates :rating, numericality: { in: 1..5 }
end
