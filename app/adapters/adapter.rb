require 'time'
require 'uri'
require 'openssl'
require 'base64'

module Adapter
  class Amazon
    attr_accessor :params
    def initialize(search_index, keyword)
      @params = nil
      @search_index = search_index
      @keyword = keyword
      @signed_url = signed_url
    end

    def aws_access_key_id
      ENV["AWSAccessKeyId"]
    end

    def aws_secret_key
      ENV["AWSSecretKey"]
    end

    def endpoint
      "webservices.amazon.com"
    end

    def request_uri
      "/onca/xml"
    end

    def set_params
      self.params = {
        "Service" => "AWSECommerceService",
        "Operation" => "ItemSearch",
        "AWSAccessKeyId" => ENV["AWSAccessKeyId"],
        "AssociateTag" => "itemer-20",
        # "SearchIndex" => "Fashion",
        "SearchIndex" => @search_index,
        # "Keywords" => "corderoy pants",
        "Keywords" => @keyword,
        "ResponseGroup" => "Images,ItemAttributes,Offers",
        "Sort" => "price"
      }
    end

    def time_params
      self.params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
    end

    def canonical_query_string
      set_params
      time_params
      params.sort.collect do |key, value|
        [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
      end.join('&')
    end

    def string_to_sign
      "GET\n#{endpoint}\n#{request_uri}\n#{canonical_query_string}"
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), ENV["AWSSecretKey"], string_to_sign)).strip()
    end

    def request_url
      "http://#{endpoint}#{request_uri}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
    end

    def signed_url
      request_url
    end
  end
end
