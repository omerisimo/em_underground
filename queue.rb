require 'eventmachine'

EM.run do
  queue = EM::Queue.new
  queue_handler = proc { |message|
    puts "Handling message #{message}"
    EM.next_tick{ queue.pop(&queue_handler) }
  }
  EM.next_tick{ queue.pop(&queue_handler) }

  EM.add_periodic_timer(0.5) do
    message = Time.now.to_s
    puts "Pushing message '#{message}' to queue"
    queue.push(message)
  end

  EM.add_timer(2) do
    puts "Shutting down EM at #{Time.now}"
    EM.stop
  end
end