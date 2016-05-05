puts 'Generating tags...'

include Jekyll::Filters

module Jekyll
	class TagPage < Page
		def initialize(site, base, dir)
			@site = site
			@base = base
			@dir = dir
			@name = 'tags.html'

			self.process(@name)
			self.read_yaml(File.join(base, '_layouts'), 'tag.html')

			tag_set = Set.new []
			site.posts.docs.each do |post|
				post.data['tags'].each do |tag|
				tag_set << tag
			  end
			end

			content_html = String.new
			content_html << '<ul class="posts">'

			tag_set.each do |curr_tag|
				content_html << <<-HTMLEND

	<li class="tag_list">
		&nbsp &raquo; &nbsp <a name="#{curr_tag}" href="#" onclick="toggle_visibility('#{curr_tag}')">#{curr_tag}</a>
		<ul id="#{curr_tag}" class="intag_list" style="display:none">
				HTMLEND

				site.posts.docs.each do |tpost|
					tpost.data['tags'].each do |tag|
						if curr_tag == tag
							content_html << <<-HTMLEND
			<li style="list-style-type: none;">
				&nbsp &nbsp &nbsp &nbsp &curren; &nbsp <span style="color:#404040">
					#{date_to_string(tpost.date)}
				</span> &nbsp &raquo; &nbsp <a href="#{tpost.url}">#{tpost.data['title']}</a>
			</li>
							HTMLEND
						end
					end
				end

				content_html << <<-HTMLEND
		</ul>
	</li>
				HTMLEND
			end

			content_html << "</ul>"

			self.content = content_html
		end
	end

	class TagGenerator < Generator
		safe true

		def generate(site)
		  site.pages << TagPage.new(site, site.source, site.source)
		end
	end
end

puts 'Tag generation done.'
