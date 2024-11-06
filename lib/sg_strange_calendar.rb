require_relative 'calendar/year'

class SgStrangeCalendar
  def initialize(year, today = nil)
    @year = Calendar::Year.new(value: year)
  end

  def generate(vertical: false)
    @year.generate
  end
end
