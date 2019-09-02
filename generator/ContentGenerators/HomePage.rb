class HomePage
    def initialize(leading_whitespace:, directory:)
        @leading_whitespace = leading_whitespace
        @directory = directory
    end

    def module_regex
        # matches things like: about.html, projects.html
        /(\s*)\{\{\s(.*)\s\}\}/
    end

    def generate(lines)
        File.read(@directory + 'index.html').each_line do |contents_line|
            content_match = contents_line.match(module_regex)
            if content_match
                template_whitespace = getLeadingWhiteSpace(content_match)
                template_filename = @directory + 'HomePage/' + content_match.captures[1]

                if File.exist?(template_filename)
                    File.read(template_filename).each_line do |template_line|
                        lines.push(' ' * template_whitespace + template_line)
                    end
                end
            else
                lines.push(' ' * @leading_whitespace + contents_line)
            end
        end
    end
end
