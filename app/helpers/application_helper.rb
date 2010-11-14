# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper   
  def title(page_title)
    content_for(:title) {"#{h(page_title)} at "}
  end

  def on_load(pre_func, post_func = nil)
    content_for(:on_load_pre) {"#{pre_func};"}
    content_for(:on_load_post) {"#{post_func};"} if post_func
  end

  def freebase_suggest(search_field, freebase_field, type_info, mql_filer = nil)
    @search_field = search_field
    @freebase_field = freebase_field
    @type_info = type_info
    @mql_filter = mql_filer

    content_for(:head) do
      render :partial => 'misc/freebase_suggest'
    end
  end

  def focus_on_load(form_item)
    content_for(:focus_on_load) {"focus_on_load('#{form_item}');"}
  end

  def can_add_users?
    APP_CONFIG['can_add_users']
  end

  def production?
      @is_production ||= (ENV['RAILS_ENV'] == 'production')
  end
end