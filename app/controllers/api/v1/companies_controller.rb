class Api::V1::CompaniesController < Api::V1::BaseController
  def index
    companies = Company.all
    render json: companies, each_serializer: Api::V1::AllCompaniesSerializer
  end
end
