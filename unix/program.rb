require "./request"
require "./device"

request = Request.new("http://localhost:3000")
m = Device.new
m.collect_data
puts request.send_data(m.device)
