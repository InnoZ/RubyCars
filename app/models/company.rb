class Company < ActiveRecord::Base
  has_many :provider, foreign_key: :company_id
  validates :id, uniqueness: true
  self.primary_key = :id
end
