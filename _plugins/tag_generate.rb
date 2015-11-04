puts 'Generating tags...'
require 'rubygems'
require 'jekyll'
include Jekyll::Filters

options = Jekyll.configuration({})
site = Jekyll::Site.new(options)
site.read_posts('')
s1 = Set.new []
html =<<-HTML
---
layout: default
title: Tags
---
<script type="text/javascript">
    function toggle_visibility(id) {
       var e = document.getElementById(id);
       if(e.style.display == 'block')
          e.style.display = 'none';
       else
          e.style.display = 'block';
    }
</script>

<h1>Tags</h1>
HTML
site.posts.each do |post|
  post.tags.each do |tag|
    s1 << tag
  end
end
html << <<-HTML
HTML
html << '<ul class="posts">'
s1.each do |s|
  html << <<-HTML
  <li class="tag_list">
    &nbsp &raquo; &nbsp <a name="#{s}" href="#" onclick="toggle_visibility('#{s}')">#{s}</a>
    <ul id="#{s}" class="intag_list" style="display:none">
    HTML
    site.posts.each do |tpost|
      tpost.tags.each do |t|
        if t == s
          html << <<-HTML
            <li style="list-style-type: none;">
              &nbsp &nbsp &nbsp &nbsp &curren; &nbsp <span style="color:#404040">#{date_to_string(tpost.date)}</span> &nbsp &raquo; &nbsp <a href="#{tpost.url}">#{tpost.title}</a>
            </li>
          HTML
        end
      end
    end
    html << <<-HTML
    </ul>
  </li>
  HTML
end
html << '</ul>'

File.open('tags.html', 'w+') do |file|
  file.puts html
end

puts 'Done.'