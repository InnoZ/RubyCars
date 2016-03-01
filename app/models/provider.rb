class Provider < ActiveRecord::Base
  belongs_to :company, foreign_key: :company_id
  has_many :station, foreign_key: :provider_id
  validates :id, uniqueness: true
  self.primary_key = :id
end
