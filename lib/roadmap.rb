module Roadmap

  def get_roadmap(roadmap_id)
    puts "Start of Get_roadmap"

    response = self.class.get(base_url("roadmaps/#{roadmap_id}"), headers: get_header)
    raise "Invalid roadmap info" if response.code != 200
    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    puts "Start of Get_checkpoint"

    response = self.class.get(base_url("checkpoints/#{checkpoint_id}"), headers: get_header)
    raise "Invalid roadmap info" if response.code != 200
    JSON.parse(response.body)
  end

 end
