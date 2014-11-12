require 'json'
require 'faraday'
require 'securerandom'

module Weixin
  module App
    class << self
      
      def prepay_id(params, access_token)
        Weixin.noncestr  = rand(10**33).to_s
        Weixin.timestamp = Time.now.to_i.to_s

        package       = Weixin::Sign.gen_package(params)
        app_signature = Weixin::Sign.gen_app_signature(package)

        data = { 'appid'         => Weixin.appid,
                 'traceid'       => 'weixin',
                 'noncestr'      => Weixin.noncestr,
                 'package'       => package,
                 'timestamp'     => Weixin.timestamp,
                 'app_signature' => app_signature,
                 'sign_method'   => 'sha1' }

        url = "https://api.weixin.qq.com/pay/genprepay?access_token=#{access_token}"
        response = Faraday.new(url){ |f| f.adapter :httpclient }.post do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = data.to_json
        end

        result = JSON.parse response.body
        result['errcode'] == 0 ? result['prepayid'] : nil
      end

    end
  end
end
