require_relative './ContentGenerators/Navigation'

# Directories >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
root_directory = '/Users/mjennings/code/masonjennings.io/'
pages_directory = root_directory + 'generator/Pages/'
wrapper_directory = pages_directory + 'Wrapper/'
component_directory = wrapper_directory + 'components/'
navigation_file = component_directory + 'Navigation.html'

# Regex >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
main_contents_regex = /(\s*)\{\{\sMainContents\s\}\}/
nav_regex = /(\s*)\{\{\sNavigation\s\}\}/
template_regex = /(\s*)\{\{\s(.*)\s\}\}/ # matches things like: Javascript.html, Footer.html

# Utils >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def getLeadingWhiteSpace(match)
    match.captures[0].length
end

# Main function >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
wrapper_file = File.read(wrapper_directory + 'PageWrapper.html')

pages = Dir.entries(pages_directory).select{ |f| File.file?(f) && !f.start_with?('.') }

pages.each do |pageName|
    lines = []

    wrapper_file.each_line do |line|
        body_match = line.match(main_contents_regex)
        navigation_match = line.match(nav_regex)
        template_match = line.match(template_regex)

        if body_match
            leading_whitespace = getLeadingWhiteSpace(body_match)
            File.read(pages_directory + pageName).each_line do |body_contents_line|
                lines.push(' ' * leading_whitespace + body_contents_line)
            end
        elsif navigation_match
            Navigation.new(
                page_name: pageName,
                leading_whitespace: getLeadingWhiteSpace(navigation_match),
                file: navigation_file,
            ).generate(lines)
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
