require 'uri'
require 'digest/sha1'
require 'digest/md5'

module Weixin
  module Sign
    class << self

      def gen_package(sign_params)
        sign_params = sign_params.merge('partner' => Weixin.partnerid)
        requires    = %w(bank_type body fee_type input_charset notify_url out_trade_no partner spbill_create_ip total_fee)
        check(sign_params, requires)
        md5_string  = Digest::MD5.hexdigest(join(sign_params, Weixin.partnerkey))

        "#{join(sign_params, nil, true)}&sign=#{md5_string.upcase}"
      end

      def gen_app_signature(package)
        sign_params = { 'appid'     => Weixin.appid,
                        'appkey'    => Weixin.appkey,
                        'noncestr'  => Weixin.noncestr,
                        'package'   => package,
                        'timestamp' => Weixin.timestamp,
                        'traceid'   => 'weixin' }
        Digest::SHA1.hexdigest(join(sign_params))
      end

      private

      def check(hash_params, requires)
        requires.each do |r|
          if !hash_params.include?(r)
            raise "Require parameter #{r}"
          end

          if hash_params['out_trade_no'] && (hash_params['out_trade_no'].length > 32 || hash_params['out_trade_no'].length < 8)
            raise "Package Error, out_trade_no's length must be between 8 and 32"
          end
        end
        hash_params
      end

      def join(sign_params, partnerkey = nil, url_encode = false)
        result_string = sign_params.sort.reduce('') do |string, array|
          value = array.last.to_s
          value = URI.escape(value) if url_encode
          string + array.first.to_s + '=' + value + '&'
        end

        partnerkey ? "#{result_string}key=#{partnerkey}" : result_string[0, result_string.length - 1]
      end

    end
  end
end
