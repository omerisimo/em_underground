require 'eventmachine'

EM.run do
  EM.add_periodic_timer(0.001) do
    puts "tick"
  end
  
  EM.add_timer(0.1) do
    (1..100).each do |index|
      puts "Procesing #{index}"
    end
    EM.stop
  end
end