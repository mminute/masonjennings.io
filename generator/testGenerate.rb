root_directory = '/Users/mjennings/code/masonjennings.io/'
pages_directory = root_directory + 'generator/Pages/'
template_directory = root_directory + 'generator/Templates/'
generated_directory = root_directory + 'generator/generated/'

index_file = File.read(pages_directory + 'index.html')

lines = []

index_file.each_line do |line|
    template_match = line.match(/(\s*)\{\{\s(.*)\s\}\}/)
    if template_match
        template_filename = template_directory + template_match.captures[1]
        leading_whitespace = template_match.captures[0].length

        if File.exist?(template_filename)
            File.read(template_filename).each_line do |template_line|
                lines.push(' ' * leading_whitespace + template_line)
            end
            next
        end
    end

    lines.push(line)
end

# IO.write(generated_directory + 'index.html', lines.join("\n"))
IO.write(root_directory + '_index.html', lines.join("\n"))