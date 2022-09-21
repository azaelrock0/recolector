require "ohai"

class Device
  attr_accessor :machine, :device, :os_family
  def initialize
    @machine = Ohai::System.new
    @machine.all_plugins
    @device = {}
    @os_family = machine.data["os"]
    validate_uuid
  end

  def validate_uuid
    if File.exist?("uuid")
      uuid = File.read("uuid")
      device[:uuid] = uuid
    else
      require "securerandom"
      uuid = SecureRandom.uuid
      device[:uuid] = uuid
      File.write("uuid", uuid)
    end
  end

  def collect_data
    device[:host_name] = host_name

    device[:cpu] = cpu

    device[:ram] = "#{ram.round} GB"

    device[:storage] = "#{storage} GB"

    device[:os] = os

    device[:ip_address] = ip
  end

  def host_name
    machine.data["hostname"]
  end

  def cpu
    machine.data["cpu"]["model_name"]
  end

  def ram
    machine.data["memory"]["total"].split("kB")[0].to_f / 1024**2
  end

  def storage
    return `lsblk | awk '{print  $4+0}' | awk 'NR==2'`.chomp if os_family == "linux"
    (machine.data["hardware"]["storage"][0]["capacity"].to_f / 1024**3).to_s
  end

  def os
    "#{machine.data["os"].capitalize} #{machine.data["platform"].capitalize} #{machine.data["platform_version"]}"
  end

  def ip
    machine.data["ipaddress"]
  end
end
