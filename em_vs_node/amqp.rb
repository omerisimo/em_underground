require 'amqp'

EventMachine.run do
  connection = AMQP.connect(:host => '0.0.0.0')
  channel  = AMQP::Channel.new(connection)
  queue   = channel.queue("my_queue")
  queue.subscribe do |metadata, payload|
    puts "Received message: #{payload}."
    EM.stop
  end

  exchange = channel.default_exchange
  exchange.publish "Hello world!", :routing_key => "my_queue"
end