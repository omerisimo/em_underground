require 'eventmachine'

EM.run do
  channel = EM::Channel.new
  
  handler_1 = proc { |message|
    puts "Handler 1 received #{message}"
  }
  
  handler_2 = proc { |message|
    puts "Handler 2 received #{message}"
  }

  channel.subscribe &handler_1
  channel.subscribe &handler_2
  
  EM.add_periodic_timer(0.5) do
    message = Time.now.to_s
    puts "Sending message '#{message}' to channel"
    channel << message
  end

  EM.add_timer(2) do
    puts "Shutting down EM at #{Time.now}"
    EM.stop
  end
end