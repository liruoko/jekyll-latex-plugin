require 'tmpdir'

module Jekyll
    module Converters
        class LaTex < Converter
            safe true

            pygments_prefix "\n"
            pygments_suffix "\n"

            def matches(ext)
                ext =~ /^\.tex$/i
            end

            def output_ext(ext)
                ".html"
            end

            def convert(content)
                Dir.mktmpdir(nil, "/tmp") {|dir|
                    texfile = "#{dir}/newpost.tex"
                    File.open("#{texfile}", 'w') {|f| f.write(content) }
                    %x[latex2html -html_version 4.0,latin1,unicode --split 0 --info 0 --address=0 -no_subdir #{texfile}]
                    html = File.read("#{dir}/index.html")
                    html.sub!(/^.*End of Navigation Panel-->/m, "")
                    html.sub!(/<\/BODY>.*$/m, "")
                    html
                }
            end
        end
    end
end
