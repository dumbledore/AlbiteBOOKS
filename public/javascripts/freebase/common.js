/*
 * content_for(element_id, [content])
 * Sets the html content of the element with the specified id.
 * If the second argument is missing it just deletes elements content. 
 */
function content_for(a) {
  text = '';
  if (arguments.length > 1) {
    text = arguments[1];
  }

  jQuery(arguments[0]).html(text);
}

function def(argument, default_value) {
  return (typeof argument == 'undefined') ? default_value : argument;
}

function make_text(elements_in, caption, separator, build_links, prefix, suffix) {
  
  caption = def(caption, '');
  separator = def(separator, '');
  build_links = def(build_links, true);
  prefix = def(prefix, '');
  suffix = def(suffix, '');

  var elements = [];
  
  if (elements_in) {
    if (elements_in.length) {
      for (var i = 0; i < elements_in.length; i++) {
        if (elements_in[i] && elements_in[i].values) {
          for (var j = 0; j < elements_in[i].values.length; j++) {
            elements.push(elements_in[i].values[j]);
          }
        }
      }
    } else if (elements_in.values) {
      elements = elements_in.values;
    }
  }

  if (elements.length > 0) {
    output = [];

    for (var i = 0; i < elements.length; i++) {
      if (elements[i].text) {
        var text = prefix + elements[i].text + suffix;

        if (build_links && elements[i].url) {
          output.push('<a href="' + elements[i].url + '" target="_blank">' + text + '</a>');
        } else {
          output.push(text);
        }
      }
    }
    
    if (caption != '') {
      return '<p><strong>' + caption + ':</strong> ' + output.join(separator) + '</p>';
    } else {
      return output.join(separator);
    }
  } else {
    return '';
  }
}

function get_wikipedia_url(webpages) {
  if (webpages) {
    for (var i = 0; i < webpages.length; i++) {
      if (webpages[i].text && webpages[i].text.toLocaleLowerCase() == 'wikipedia' && webpages[i].url) {
        return webpages[i].url;
      }
    }
  }

  return null;
}

function make_links(freebase_url, wikipedia_url, webpages) {
  if (freebase_url || wikipedia_url || webpages) {
    output = '<h1>Elsewhere on the web</h1>';

    if (freebase_url) {
      output += '<p class="linklist"><image src="' + images_url + 'misc/freebase.gif" alt="Freebase"> <a href="' + freebase_url + '" target="new">Freebase</a></p>';
    }

    if (wikipedia_url) {
      output += '<p class="linklist"><image src="' + images_url + 'misc/wikipedia.gif" alt="Wikipedia"> <a href="' + wikipedia_url + '" target="new">Wikipedia</a></p>';
    }

    if (webpages) {
      for (var i = 0; i < webpages.length; i++) {
        if (webpages[i].text && webpages[i].text.toLocaleLowerCase() != 'wikipedia' && webpages[i].url) {
          output += '<p class="linklist"><a href="' + webpages[i].url + '" target="_blank">' + webpages[i].text + '</a></p>';
        }
      }
    }

    content_for("#freebase_links", output);
  }
}

function make_quotes(quotes) {
  if (quotes) {
    content_for("#freebase_quotes", '<h1>Quotes</h1>' + make_text(quotes, '', '', false, '<p class="quote">&ldquo;&nbsp;', '&nbsp;&rdquo;</p>'));
  }
}