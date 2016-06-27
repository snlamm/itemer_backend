require 'open-uri'

class ProductInfoController < ApplicationController
  def index
    amazon_url = Adapter::Amazon.new("Fashion", "corderoy pants")
    binding.pry
    response =  Nokogiri::HTML(open(amazon_url.signed_url))
  end
end
