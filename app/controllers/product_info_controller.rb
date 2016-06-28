require 'open-uri'

class ProductInfoController < ApplicationController
  def index
    amazon_url = Adapter::Amazon.new("Fashion", "corderoy pants")
    response =  Nokogiri::XML(open(amazon_url.signed_url))
    parsed_response = ParseData.new(response).values
  end
end
