# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
Mime::Type.register_alias 'application/xhtml+xml', :mobile

#Rack::Mime::MIME_TYPES.merge!({
#  ".jad" => "text/vnd.sun.j2me.app-descriptor",
#  ".jar" => "application/java-archive",
#  ".epub" => "application/epub+zip"
#  })

Mongrel::DirHandler::add_mime_type('.epub', 'application/epub+zip')
Mongrel::DirHandler::add_mime_type('.jad', 'text/vnd.sun.j2me.app-descriptor')
