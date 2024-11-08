module Calendar
  class Table
    def initialize(rows:, today: nil)
      @rows = rows
      @today = today
    end

    def generate(vertical: false)
      vertical ? generate_with_vertical : generate_with_horizontal
    end

    private

    def generate_with_horizontal
      header = @rows.first.join(' ')
      body = @rows[1..].map do |row|
        [
          "#{row.first} ",
          *row[1..].map do |cell|
            if cell.is_a?(Date)
              string_format = cell == @today ? '[%-d]' : '%_2d'
              cell.strftime(string_format)
            else
              '  '
            end
          end
        ].join(' ')
      end
      text = [header, *body].join("\n")
      return text unless @today

      replace_today(text:, today: @today)
    end

    def generate_with_vertical
      header = transposed_rows.first.join(' ')
      body = transposed_rows[1..].map do |row|
        [
          "#{row.first}  ",
          *row[1..].map do |cell|
            if cell.is_a?(Date)
              cell.strftime('%_3d')
            else
              '   '
            end
          end
        ].join(' ').rstrip
      end
      if @today
        month_index = @today.month
        wday_index = Date.new(@today.year, @today.month, 1).wday + @today.day - 1
        result = /^(.{#{(month_index - 1) * 4 + 5}}(?<today>(\s{0,2})\b#{@today.day}\b\s?))/.match(body[wday_index])
        captured_today = result[:today]
        capture = result.to_a[0]
        body[wday_index].gsub!(capture, capture[..(capture.length - captured_today.length)] + "#{' ' if @today.day > 9}[#{@today.day}]")
      end
      [header, *body].join("\n")
    end

    def transposed_rows
      return @transposed_rows if @transposed_rows

      max_length = @rows.map { |row| row.length }.max
      filled_rows = @rows.map do |row|
        row + [''] * (max_length - row.length)
      end
      @transposed_rows = filled_rows.transpose
    end

    def replace_today(text:, today:)
      result = /[^\S\n\r]\[(#{today.day})\][^\S\n\r]?/.match(text)
      captured = result.to_a[0]
      text.gsub(captured, today.day > 9 ? captured.strip : captured.rstrip)
    end
  end
end

