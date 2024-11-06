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
              cell.strftime('%_2d')
            else
              '  '
            end
          end
        ].join(' ')
      end
      if @today
        body[@today.month - 1].gsub!(/\s\b#{@today.day}\b\s?/, "[#{@today.day}]")
      end
      [header, *body].join("\n")
    end

    def generate_with_vertical
    end
  end
end

