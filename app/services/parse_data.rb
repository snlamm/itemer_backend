class ParseData

  attr_accessor :data, :values
  def initialize(data)
    @values = {}
    @data = data
    data_parse
  end

  private

  def data_parse
    product_names
    urls
    prices
    images
  end

  def product_names
    parsed_response = data.css("Title").collect {|x| x.children.text}
    self.values["product_names"] = parsed_response
  end

  def urls
    parsed_response = data.css("DetailPageURL").collect {|x| x.children.text}
    self.values["detail_page_urls"] = parsed_response
  end

  def prices
    parsed_response = data.css("Price FormattedPrice").collect {|x| x.children.text}
    self.values["prices"] = parsed_response
  end

  def images
    parsed_response = data.css("Item").collect do |x|
      x.css("MediumImage").css("URL").children.first.text
    end
    self.values["images"] = parsed_response
  end
end
