require 'date'

module Calendar
  class Month
    NAMES = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

    def initialize(year:, value:)
      @year = year
      @value = value
      @name = NAMES[@value - 1]
      @day_count = day_count
      @dates = (1..@day_count).map { |number| Date.new(@year.value, @value, number) }
    end

    def generate
      line = "#{@name}  " + ' ' * (3 * first_date_wday)
      line + @dates.map do |date|
        next date.strftime('%_2d ') if @year.today.nil?

        next_day = date.next_day
        case @year.today
        when date
          date_string = date.strftime('%-d')
          if date_string == '1'
            "[#{date_string}]"
          else
            ''
          end
        when next_day
          next_day_string = next_day.strftime('%-d')
          date.strftime('%_2d') + (next_day_string.length > 1 ? '' : ' ') + "[#{next_day_string}]"
        else
          date.strftime('%_2d ')
        end
      end.join.rstrip
    end

    def first_date_wday
      @dates.first.wday
    end

    private

    def day_count
      case @value
      when 1, 3, 5, 7, 8, 10, 12 then 31
      when 4, 6, 9, 11 then 30
      when 2
        @year.leap_year? ? 29 : 28
      else
        raise 'Invalid month'
      end
    end
  end
end
