require 'open-uri'

class ProductInfoController < ApplicationController
  def index
    amazon_url = Adapter::Amazon.new("Fashion", "corderoy pants")
    binding.pry
    response =  Nokogiri::XML(open(amazon_url.signed_url))
    collect_data(response)

  end

  private
  def collect_data(response)
    product_names = response.css("Title").collect {|x| x.children.text}
    detail_page_urls = response.css("DetailPageURL").collect {|x| x.children.text}
    price = response.css("Price FormattedPrice").collect {|x| x.children.text}
  end
end
