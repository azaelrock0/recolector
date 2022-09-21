require "faraday"

class Request
  attr_accessor :conn
  def initialize(url)
    @conn = Faraday.new(
      url: url,
      headers: {"Content-Type" => "application/json"}
    )
  end

  def send_data(data)
    response = conn.post("/recollector") do |req|
      req.body = {device: data}.to_json
    end
  end
end
