require 'weixin/sign'
require 'digest/sha1'
require 'digest/md5'
require 'json'

module Weixin
  class AppApi
    attr_accessor :appid, :appsecret, :partnerid, :partnerkey

    include Weixin::Sign

    def initialize(configs = {})
      check_configs(configs)
      @appid      = configs[:appid]
      @appsecret  = configs[:appsecret]
      @partnerid  = configs[:partnerid]
      @partnerkey = configs[:partnerkey]
      @appkey     = configs[:appkey]
      @noncestr   = rand(10**33).to_s
      @timestamp  = Time.now.to_i.to_s
    end

    def prepay_id(params, access_token)
      package       = gen_package(params)
      app_signature = gen_app_signature(package)

      data = { 'appid'         => @appid,
               'traceid'       => 'weixin',
               'noncestr'      => @noncestr,
               'package'       => package,
               'timestamp'     => @timestamp,
               'app_signature' => app_signature,
               'sign_method'   => 'sha1' }

      url = "https://api.weixin.qq.com/pay/genprepay?access_token=#{access_token}"
      conn = Faraday.new(url) do |f|
        f.adapter :httpclient
      end
      response = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = data.to_json
      end

      result = JSON.parse response.body
      result['errcode'] == 0 ? result['prepayid'] : nil
    end

    private
    def check_configs(configs = {})
      requires = [:appid, :appsecret, :partnerid, :partnerkey, :appkey]
      check(configs, requires)
    end

    def gen_package(sign_params)
      sign_params = sign_params.merge(:partner => @partnerid)
      check_package(sign_params)
      md5_string  = Digest::MD5.hexdigest(join(sign_params, @partnerkey))

      "#{join(sign_params, nil, true)}&sign=#{md5_string.upcase}"
    end

    def gen_app_signature(package)
      sign_params = { :appid     => @appid,
                      :appkey    => @appkey,
                      :noncestr  => @noncestr,
                      :package   => package,
                      :timestamp => @timestamp,
                      :traceid   => 'weixin' }
      Digest::SHA1.hexdigest join(sign_params)
    end

    def check_package(sign_params)
      requires = [:bank_type,     :body,             :fee_type, 
                  :input_charset, :notify_url,       :out_trade_no, 
                  :partner,       :spbill_create_ip, :total_fee ]
      
      check(sign_params, requires)
      if sign_params[:out_trade_no].length > 32
        raise "Package Error, out_trade_no's length can't be longer than 32" 
      end
      if sign_params[:out_trade_no].length < 8
        raise "Package Error, out_trade_no's length can't be shorter than 8" 
      end
      sign_params
    end
  end
end
