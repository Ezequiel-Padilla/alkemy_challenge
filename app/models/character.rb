# frozen_string_literal: true

class Character < ApplicationRecord
  has_one_attached :image
  belongs_to :programs
end
