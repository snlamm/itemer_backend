require 'open-uri'

class ProductInfoController < ApplicationController
  def index
    binding.pry
    amazon_url = Adapter::Amazon.new(params[:category], params[:keywords])
    response =  Nokogiri::XML(open(amazon_url.signed_url))
    parsed_response = ParseData.new(response).values
    render json: parsed_response
  end
end
