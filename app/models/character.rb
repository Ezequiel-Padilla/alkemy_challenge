# frozen_string_literal: true

class Character < ApplicationRecord
  has_one_attached :image
  has_many :programs
end
