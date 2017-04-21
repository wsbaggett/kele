require 'httparty'
require 'json'

 class Kele
  include HTTParty
  base_uri = 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    puts "Start of Initialize!"

    values = {
        email: email,
        password: password
    }

    response = self.class.post(base_url('/sessions'), body: values)
    raise "Invalid email or password" if response.code != 200
    @author_token = response["auth_token"]
  end

  def get_me
    puts "Start of Get_me!"

    headers = {
     :content_type => 'application/json',
     :authorization => @author_token
    }

   response = self.class.get(base_url('/users/me'), headers: headers)
   raise "Invalid user info" if response.code != 200
   @my_info = JSON.parse(response.body)
  end

  private

  def base_url(tag)
    "https://www.bloc.io/api/v1/#{tag}"
  end

end
