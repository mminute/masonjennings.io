require_relative './HomePage'

class MainContents
    def initialize(page_name:, leading_whitespace:, directory:)
        @page_name = page_name
        @leading_whitespace = leading_whitespace
        @directory = directory
    end

    def generate(lines)
        if @page_name.match(/index\.html/)
            HomePage.new(
                directory: @directory,
                leading_whitespace: @leading_whitespace,
            ).generate(lines)
        else
            File.read(@directory + @page_name).each_line do |body_contents_line|
                lines.push(' ' * @leading_whitespace + body_contents_line)
            end
        end
    end
end