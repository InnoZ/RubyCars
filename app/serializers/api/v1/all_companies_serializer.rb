class Api::V1::AllCompaniesSerializer < ActiveModel::Serializer

  attributes :id, :providers

  #has_many :provider, serializer: Api::V1::ProviderOverviewSerializer
  # To get the plural key 'providers', the method below has to be used instead
  def providers
    ActiveModel::ArraySerializer.new(object.provider, each_serializer: Api::V1::ProviderOverviewSerializer)
  end

  def href
    "/v1/companies/#{object.id}"
  end
end
