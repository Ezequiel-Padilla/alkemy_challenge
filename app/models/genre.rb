# frozen_string_literal: true

class Genre < ApplicationRecord
  has_one_attached :image
  has_many :programs
end
