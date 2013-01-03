require 'recursive_open_struct'

class UserMapper
  attr_reader :auth
  attr_reader :info
  def initialize(auth_data)
    @auth = RecursiveOpenStruct.new(auth_data)
  end

  def attr_hash
    attributes = {
      provider: auth.provider,
      uid: auth.uid,
      token: auth.credentials.token
    }
    unless info.nil?
      attributes[:nickname] = info.nickname
      attributes[:name] = info.name
      attributes[:image] = info.image
      attributes[:bio] = info.bio
      attributes[:website] = info.website
      attributes[:email] = info.email
    end
    attributes
  end

  def info
    auth.info
  end

end
