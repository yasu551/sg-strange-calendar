require_relative 'month'
require 'date'

module Calendar
  class Year
    VERTICAL_BODY_ROW_COUNT = 37
    WEEKDAY_COUNT = 7

    attr_reader :value, :today

    def initialize(value:, today: nil)
      @value = value
      @today = today
      @months = (1..Month::NAMES.size).map { |value| Month.new(year: self, value:) }
    end

    def leap_year?
      date = Date.new(@value, 1, 1)
      date.leap?
    end

    def generate(vertical: false)
      lines = [header(vertical:), *@months.map { |month| month.generate(vertical:) }]
      lines.join("\n")
    end

    private

    def header(vertical: false)
      vertical ? header_with_vertical : header_with_horizontal
    end

    def header_with_horizontal
      "#{@value} " + 'Su Mo Tu We Th Fr Sa ' * 5 + 'Su Mo'
    end

    def header_with_vertical
      [@value.to_s, Month::NAMES].join(' ')
    end
  end
end
