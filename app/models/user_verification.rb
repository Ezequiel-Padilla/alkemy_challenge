# frozen_string_literal: true

class UserVerification < ApplicationRecord
  belongs_to :user
end
