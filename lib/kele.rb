require 'httparty'

 class Kele
  include HTTParty
  base_uri = 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    puts "Start of Initialize method!"

    values = {
        email: email,
        password: password
    }

    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: values)
    @author_token = response["auth_token"]

    raise "Invalid email or password!" if !@author_token
  end
end
