# coding: utf-8
Gem::Specification.new do |spec|
  spec.authors = ["Kungs"]
  spec.description = %q(weixin is ruby SDK for weixin pay.)
  spec.email = "kungs.yung@gmail.com"
  spec.homepage = "https://github.com/kungs/weixin"
  spec.licenses = %w[MIT]
  spec.name = "weixin"
  spec.files = `git ls-files`.split("\n")
  spec.require_paths = %w[lib]
  spec.summary = %q(weixin SDK for ruby)
  spec.version = '1.0.0'

  spec.add_dependency("faraday")
  spec.add_dependency("httpclient")
  spec.add_dependency("json")

  spec.add_development_dependency "minitest", '~> 5'
end
