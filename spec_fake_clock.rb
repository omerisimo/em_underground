require 'rspec/em'

class LazyCalculator
  include EM::Deferrable

  def divide(x, y)
    EM.add_timer(1.0) do
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
  include RSpec::EM::FakeClock
  before { clock.stub }
  after { clock.reset }
  
  it "it divides x by y" do
    calc = LazyCalculator.new.divide(6,3)
    expect(calc).to receive(:succeed).with 2
    clock.tick(1)
  end

  it "fails when dividing by zero" do
    calc = LazyCalculator.new.divide(6,0)
    expect(calc).to receive(:fail).with(kind_of(ZeroDivisionError))
    clock.tick(1)
  end
end