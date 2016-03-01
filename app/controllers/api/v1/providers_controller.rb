class Api::V1::ProvidersController < Api::V1::BaseController
  def show
    provider = Provider.find(params[:id])
    render json: Api::V1::ProviderDetailsSerializer.new(provider)
  end
end
