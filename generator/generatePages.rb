root_directory = '/Users/mjennings/code/masonjennings.io/'
pages_directory = root_directory + 'generator/Pages/'
wrapper_directory = pages_directory + 'Wrapper/'
component_directory = wrapper_directory + 'components/'

main_contents_regex = /(\s*)\{\{\sMainContents\s\}\}/
template_regex = /(\s*)\{\{\s(.*)\s\}\}/

def getLeadingWhiteSpace(match)
    match.captures[0].length
end

wrapper_file = File.read(wrapper_directory + 'PageWrapper.html')


Dir.entries(pages_directory).select{ |f| File.file? f }.each do |pageName|
    lines = []

    wrapper_file.each_line do |line|
        body_match = line.match(main_contents_regex)
        template_match = line.match(template_regex)

        if body_match
            leading_whitespace = getLeadingWhiteSpace(body_match)
            File.read(pages_directory + pageName).each_line do |body_contents_line|
                lines.push(' ' * leading_whitespace + body_contents_line)
            end
        elsif template_match
            leading_whitespace = getLeadingWhiteSpace(template_match)
            template_filename = component_directory + template_match.captures[1]

            if File.exist?(template_filename)
                File.read(template_filename).each_line do |template_line|
                    lines.push(' ' * leading_whitespace + template_line)
                end
            end
        else
            lines.push(line)
        end
    end

    IO.write(root_directory + '_' + pageName, lines.join())
end
