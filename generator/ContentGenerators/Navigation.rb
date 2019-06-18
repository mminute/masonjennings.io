class Navigation
    def initialize(page_name:, leading_whitespace:, file:)
        @page_name = page_name
        @leading_whitespace = leading_whitespace
        @file = file
    end

    def classes_regex
        /\{\{ ClassNames \}\}/
    end

    def links_regex
        /(\s*)\{\{ Links \}\}/
        # Get leading whitespace?
    end

    def page_to_links
        home = { link: 'index.html', txt: 'Home' }
        contact = { link: 'contact.html', txt: 'Contact' }

        {
            'contact.html': [home],
            'index.html': [
                { link: '#about-me', txt: 'About Me' },
                { link: '#my-languages', txt: 'Languages' },
                { link: '#my-projects', txt: 'Projects' },
                { link: 'resume.html', txt: 'Resume' },
                contact,
                { link: 'interests.html', txt: 'Interests' },
            ],
            'interests.html': [],
            'resume.html': [contact, home],
            'thanks.html': [home],
        }
    end

    def generate(lines)
        nav_classes = "navbar navbar-custom navbar-fixed-top"
        if @page_name.match('index') || @page_name.match('thanks')
            nav_classes = nav_classes + " navbar-transparent"
        end

        File.read(@file).each_line do |line|
            _line = line

            if line.match(classes_regex)
                _line = line.gsub(classes_regex, nav_classes)
                lines.push(' ' * @leading_whitespace + _line)
            elsif line.match(links_regex)
                link_leading_whitespace = ' ' * (line.match(links_regex).captures[0].length + @leading_whitespace)
                page_to_links[@page_name.to_sym].each { |link|
                    lines.push(link_leading_whitespace + "<li><a href=\"#{link[:link]}\">#{link[:txt]}</a></li>\n")
                }
            end
        end
    end
end