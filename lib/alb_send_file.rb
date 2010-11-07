def alb_send_file(path, name)
  response.headers['X-Sendfile'] = path
  response.headers['Content-Disposition'] = "attachment; filename=#{name}"
  render :nothing => true
end