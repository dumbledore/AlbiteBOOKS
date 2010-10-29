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

function make_text(elements, caption, separator, build_links, prefix, suffix) {
  
  caption = def(caption, '');
  separator = def(separator, '');
  build_links = def(build_links, true);
  prefix = def(prefix, '');
  suffix = def(suffix, '');

  if (elements && elements.values) {
    output = [];

    for (var i = 0; i < elements.values.length; i++) {
      if (elements.values[i].text) {
        var text = prefix + elements.values[i].text + suffix;

        if (build_links && elements.values[i].url) {
          output.push('<a href="' + elements.values[i].url + '">' + text + '</a>');
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
  if (webpages) {
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
          output += '<p class="linklist"><a href="' + webpages[i].url + '" target="new">' + webpages[i].text + '</a></p>';
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