require 'securerandom'
require 'uri'
require 'faraday'

module Weixin
  module Sign
    def check(hash_params, requires)
      requires.each do |r|
        unless hash_params.include? r
          raise "Require parameter :#{r}"
        end
      end
      hash_params
    end

    def join(sign_params, partnerkey = nil, url_encode = false)
      result_string = sign_params.sort.reduce('') do |string, array|
        value = array.last.to_s
        if url_encode
          regexp = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
          value  = URI.escape(value, regexp)
        end
        string + array.first.to_s + '=' + value + '&'
      end

      if partnerkey
        "#{result_string}key=#{partnerkey}"
      else
        result_string[0, result_string.length - 1]
      end
    end
  end
end
