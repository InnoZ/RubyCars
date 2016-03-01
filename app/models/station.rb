class Station < ActiveRecord::Base
  belongs_to :provider, foreign_key: :provider_id
  belongs_to :region, foreign_key: :region_id
  validates :id, uniqueness: true
  self.primary_key = :id
end
