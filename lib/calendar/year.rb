require_relative 'month'

module Calendar
  class Year
    attr_reader :value

    def initialize(value:)
      @value = value
      @months = (1..Month::NAMES.size).map { |value| Month.new(year: self, value:) }
    end

    def leap_year?
      (@value % 4).zero? && ((@value % 100).nonzero? || (@value % 400).zero?)
    end

    def generate
      lines = [header, *@months.map(&:generate)]
      lines.join("\n")
    end

    private

    def header
      "#{@value} " + 'Su Mo Tu We Th Fr Sa ' * 5 + 'Su Mo'
    end
  end
end
