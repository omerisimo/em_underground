require 'eventmachine'

EM.run do
  EM.add_periodic_timer(0.001) do
    puts "tick"
  end
  
  EM.add_timer(0.1) do
    index = 0
    process_index = proc{
      if index < 100
        puts "Procesing #{index}"
        index += 1
        EM.next_tick &process_index
      else
        EM.stop
      end
    }
    EM.next_tick &process_index
  end
end