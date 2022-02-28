# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user
  before_validation :generate_token, on: :create

  after_create :used

  validates :token, presence: true
  validates :user_id, presence: true

  def late?
    return false unless (last_used_at + 1.hour) >= Time.now

    close
    true
  end

  def self.search(user_id, token)
    Session.find_by(user_id: user_id, token: token, status: true)
  end

  def used
    update(last_used_at: Time.now)
  end

  def close
    update(status: false)
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.base58(32)
      break random_token unless Session.exists?(token: random_token)
    end
  end
end
