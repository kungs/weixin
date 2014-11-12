require 'weixin/sign'
require 'weixin/app'

module Weixin
  class << self
    attr_accessor :appid, :appsecret, :partnerid, :partnerkey, :appkey, :timestamp, :noncestr
  end
end