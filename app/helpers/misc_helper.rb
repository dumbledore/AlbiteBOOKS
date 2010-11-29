module MiscHelper
  def letters_index(hide, title, letter_name = nil)
    unless hide
      letters = [link_to('#', {:letter => '*'}, :class => 'letter')]

      for letter in 'A'..'Z'
        letters << link_to(letter, {:letter => letter}, :class => 'letter')
      end

      %[
          <h1 class="letter">
            #{title}
            <span class="letter">#{letter_name}</span><br />
            #{letters.join(' | ')}
          </h1>
      ]
    else
      %[<h1>#{title}</h1>]
    end
  end

  def ajax_div(id)
    %[<div id="#{id}"><div class="loading">Loading... #{image_tag '_/loading.gif'}</div></div>]
  end

  def ajax_span(id)
    %[<span id="#{id}"><span class="loading">Loading... #{image_tag '_/loading.gif'}</span></span>]
  end

  def youtube(url, width, height)
    %[
      <div class="youtube">
        <object width="#{width}" height="#{height}">
          <param name="movie" value="#{url}" />
          <param name="allowFullScreen" value="true" />
          <param name="allowscriptaccess" value="always" />
          <param name="wmode" value="transparent" />
          <embed width="#{width}" height="#{height}"
                 src="#{url}"
                 type="application/x-shockwave-flash"
                 allowscriptaccess="always"
                 allowfullscreen="true"
                 wmode="transparent"
                 />
        </object>
      </div>
    ]
  end
end