class MixedController < ApplicationController
  before_filter :require_admin, :only => ['new', 'create', 'edit', 'update', 'destroy']
  require 'lib/lettercode.rb'
  include Lettercode

  def select
    if is_id params[:id]
      show
    else
      index
    end
  end
end