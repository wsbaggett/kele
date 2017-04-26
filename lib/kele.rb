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

  def get_messages(*page_num)
    puts "Start of Get_messages"

    page = page_num[0].to_i
    values = {
    "page": page
    }

    if page == nil
      response = self.class.get(base_url("message_threads"), headers: get_header)
    else
      response = self.class.get(base_url("message_threads"), values: values, headers: get_header)
    end
    raise "Invalid get messages error" if response.code != 200
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, text)
    puts "Start of Create_message"

    values = {
    "sender": sender,
    "recipient_id": recipient_id.to_i,
    "token": token,
    "subject": subject,
    "stripped-text": text
    }

    puts "Values = #{values}"

    # The create_message will not work on the Production server URL due to it being a student account as per the Bloc Slack channel.
    # response = self.class.post(base_url("messages"), values: values, headers: get_header)

    # Does work on the mock server URL below
    response = self.class.post('https://private-anon-a16d2c6b9c-blocapi.apiary-mock.com/api/v1/messages', values: values, headers: get_header)
    raise "Error creating message" if response.code != 200
    puts response.body
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    puts "Start of create submission"

    enrollment_id = @my_info["current_enrollment"]["id"]

    values = {
    "assignment_branch": assignment_branch,
    "assignment_commit_link": assignment_commit_link,
    "checkpoint_id": checkpoint_id,
    "comment": comment,
    "enrollment_id": enrollment_id
    }

    response = self.class.post(base_url("checkpoint_submissions"), values: values, headers: get_header)
    raise "Error creating checkpoint" if response.code != 200
    JSON.parse(response.body)
  end

  def update_submission(submission_id, checkpoint_id, assignment_branch, assignment_commit_link, comment)
    puts "Start of update submission"

    enrollment_id = @my_info["current_enrollment"]["id"]

    values = {
    "assignment_branch": assignment_branch,
    "assignment_commit_link": assignment_commit_link,
    "checkpoint_id": checkpoint_id,
    "comment": comment,
    "enrollment_id": enrollment_id
    }

    response = self.class.put(base_url("checkpoint_submissions/#{submission_id}"), values: values, headers: get_header)
    raise "Error updating checkpoint" if response.code != 200
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
