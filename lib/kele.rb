require 'httparty'
require 'json'
require '/Users/baggetws/bloc/kele/lib/roadmap'

 class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    puts "Start of Initialize!"

    values = {
        email: email,
        password: password
    }

    response = self.class.post(base_url("sessions"), body: values)
    raise "Invalid email or password" if response.code != 200
    @author_token = response["auth_token"]
  end

  def get_me
    puts "Start of Get_me!"

   response = self.class.get(base_url("users/me"), headers: get_header)
   raise "Invalid user info" if response.code != 200
   @my_info = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    puts "Start of Get_mentor_availability"

    response = self.class.get(base_url("mentors/#{mentor_id}/student_availability"), headers: get_header)
    raise "Invalid mentor info" if response.code != 200
    JSON.parse(response.body)
  end

  private

  def base_url(tag)
    "https://www.bloc.io/api/v1/#{tag}"
  end

  def get_header
    headers = {
     :content_type => 'application/json',
     :authorization => @author_token
    }
  end

end
