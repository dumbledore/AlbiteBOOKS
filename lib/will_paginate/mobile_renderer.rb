#      renderer.prepare collection, options, self
#      renderer.to_html

require 'vendor/plugins/will_paginate/lib/will_paginate/view_helpers'

module WillPaginate
  class MobileRenderer < WillPaginate::LinkRenderer
#    def prepare(collection, options, template)
#      @collection = collection
#      @template = template
#    end

    include MobileHelper

    def to_html
      require 'app/helpers/mobile_helper.rb'

      html = String.new
      html << '<table class="pages"><tr>'

      # Previous page
      if @collection.previous_page and @collection.previous_page != current_page
        html << %[<td class="page">#{mobile_link_to(url_for(@collection.previous_page), '&nbsp;', nil, false, 'back')}</td>]
      else
        html << '<td class="no_page"></td>'
      end

      # Current page
      html << %[<td><p class="curr_page">Page ##{current_page} of #{total_pages}</p></td>]

      # Next page
      if @collection.next_page and @collection.next_page != current_page
        html << %[<td class="page">#{mobile_link_to(url_for(@collection.next_page), '&nbsp;')}</td>]
      else
        html << '<td class="no_page"></td>'
      end

      html << '</tr></table>'

      if html.respond_to?(:html_safe)
        html.html_safe
      else
        html
      end
    end
  end
end