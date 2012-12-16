require 'recursive_open_struct'

class UserMapper
  attr_accessor :auth
  def initialize(auth_data)
    @auth = RecursiveOpenStruct.new(auth_data)
  end

  def attr_hash
    {
      provider: auth.provider,
      uid: auth.uid,
      token: auth.credentials.token,
      name: auth.info.name || "",
      nickname: auth.info.nil? ? '' : auth.info.nickname,
      email: auth.info.nil? ? '' : auth.info.email
    }
  end

end
