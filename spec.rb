require 'em-spec/rspec'

class LazyCalculator
  include EM::Deferrable

  def divide(x, y)
    EM.add_timer(0.1) do
      if(y == 0)
        fail ZeroDivisionError.new
      else
        result = x/y
        succeed result
      end
    end
    self
  end
end


describe LazyCalculator do
  include EM::SpecHelper
  default_timeout(0.2)

  it "divides x by y" do
    em do
      calc = LazyCalculator.new.divide(6,3)
      calc.callback do |result|
        expect(result).to eq 2
        done
      end
    end
  end

  it "fails when dividing by zero" do
    em do
      calc = LazyCalculator.new.divide(6,0)
      calc.errback do |error|
        expect(error).to be_a ZeroDivisionError
        done
      end
    end
  end
end