# Winxin

A simple Wechat pay ruby gem.


## Installation

Add this line to your Gemfile:

```ruby
gem 'weixin'
```

And then execute:

```sh
$ bundle
```

## Usage

### Config

```ruby
# required
Weixin.appid      = 'YOUR_APPID'
Weixin.appsecret  = 'YOUR_APPSECRET'
Weixin.partnerid  = 'YOUR_PARTNERID'
Weixin.partnerkey = 'YOUR_PARTNERKEY'
Weixin.appkey     = 'YOUR_APPKEY'
```

### APIs

**Check official document for detailed request params and return fields**

#### unifiedorder

```ruby
# required fields 
params = {
'bank_type' => 'WX'
'body' => 'test',
'fee_type' => '',
'out_trade_no' => '123456789',
'total_fee' 1,
'spbill_create_ip' '127.0.0.1',
'notify_url' 'http://making.dev'
}
Weixin::App.prepay_id(params, 'YOUR_ACCESS_TOKEN')
```


## Contributing

Bug report or pull request are welcome.


### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.


## License

This project rocks and uses MIT-LICENSE.
