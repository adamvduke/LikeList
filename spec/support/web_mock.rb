require 'webmock'
include WebMock::API
include LikeIt::Helpers

stub_request(:get, /https:\/\/api.instagram.com\/v1\/users\/self\/media\/liked\/\?access_token=.*/).
  to_return({body: fixture("likes.json") })
