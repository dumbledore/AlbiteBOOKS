# Parse  app's config file
# =====================

# 1. Use the file 'albite.yml' to set-up your app config: either directly in it, or just by using it as a template
# 2. Specify 'albite.yml' or the name of the file where you keep your app's config. Default is to my custom file
#    which is not tracked by git.
#APP_CONFIG = YAML.load_file Rails.root.join('config', 'albite.custom.yml')
APP_CONFIG = YAML.load_file File.join(RAILS_ROOT, 'config', 'albite.custom.yml')

# Setup SMTP
# ========
ActionMailer::Base.smtp_settings = APP_CONFIG['smtp']

# Setup Recaptcha
# =============
ENV['RECAPTCHA_PUBLIC_KEY']  = APP_CONFIG['recaptcha_public_key']
ENV['RECAPTCHA_PRIVATE_KEY'] = APP_CONFIG['recaptcha_private_key']

# Setup secret token
# ===============
ActionController::Base.session = {
  :key         => '_albite_session',
  :secret      => APP_CONFIG['secret_token']
}