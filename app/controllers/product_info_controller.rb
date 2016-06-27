class ProductInfoController < ApplicationController
  def index
    amazon_url = Adapter::Amazon.new("Fashion", "corderoy pants")
    
    binding.pry
  end
end
