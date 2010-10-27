function freebase(freebase_uid) {

  if (!freebase_uid) {
    clearAll();
    return;
  }

  // Adding callback=? to the URL makes jQuery do JSONP instead of XHR.
  jQuery.getJSON("http://www.freebase.com/experimental/topic/standard?callback=?&id=" + freebase_uid,
  displayResults);                     // Callback function

  function clearAll() {
    content_for("#freebase_description");
    content_for("#freebase_bio");
    content_for("#freebase_links");
    content_for("#freebase_quotes")
  }

  function displayResults(response) {

    clearAll();

    if (response[freebase_uid] && response[freebase_uid].code == "/api/status/ok" && response[freebase_uid].result) {
      var res = response[freebase_uid].result;
      var output = "";

      //wikipedia url
      wikipedia_url = null;
      if (res.webpage) {
        for (var i=0; i < res.webpage.length; i++) {
          if (res.webpage[i].text && res.webpage[i].text.toLocaleLowerCase() == 'wikipedia') {
            wikipedia_url = res.webpage[i].url;
            break;
          }
         }
       }

      //description
      if (res.description) {
        output += res.description;
        if (wikipedia_url)
          output += ' <a href="' + wikipedia_url + '" target="new">more at Wikipedia</a>';
        content_for("#freebase_description", output);
      }

      if (res.properties) {
        //property-dependent attributes

        //biography
        output = "";

        //born
        if (
            res.properties['/people/person/date_of_birth'] ||
            res.properties['/people/person/place_of_birth']
        )
        {
          output +="<p><strong>Born:</strong> ";

          if (res.properties['/people/person/date_of_birth'])
            output += res.properties['/people/person/date_of_birth'].values[0].text;

          if (res.properties['/people/person/place_of_birth']) {
            if (res.properties['/people/person/date_of_birth'])
              output +=", ";
            output += res.properties['/people/person/place_of_birth'].values[0].text;
          }
          output += "</p>";
        }

        //died
        if (
                res.properties['/people/deceased_person/date_of_death'] ||
                res.properties['/people/deceased_person/place_of_death']
        )
        {
          output += "<p><strong>Died:</strong> ";

          if (res.properties['/people/deceased_person/date_of_death'])
            output += res.properties['/people/deceased_person/date_of_death'].values[0].text;

          if (res.properties['/people/deceased_person/place_of_death']) {
            if (res.properties['/people/deceased_person/date_of_death'].values[0].text)
              output += ", ";
            output += res.properties['/people/deceased_person/place_of_death'].values[0].text;
          }
          output += "</p>";
        }

        //nationality
        if (res.properties['/people/person/nationality'])
          output += "<p><strong>Country of nationality:</strong> " + res.properties['/people/person/nationality'].values[0].text + "</p>";

        //profession
        if (res.properties['/people/person/profession']) {
          var professions = res.properties['/people/person/profession'].values;
          var professions_ = [];
          if (professions.length > 0) {
            for (var j=0; j<professions.length; j++) {
              if (professions[j].text) {
                professions_.push(professions[j].text);
              }
            }
          }
          output += "<p><strong>Worked as:</strong> " + professions_.join(', ');
        }

        content_for("#freebase_bio", output);

        //quotes

        if (res.properties['/people/person/quotations']) {
          output = '<h1>Quotes</h1>';
          var quotes =res.properties['/people/person/quotations'].values;

          for (var i=0; i < quotes.length; i++) {
            if (quotes[i].text) {
              output += '<p class="quote">&ldquo;&nbsp;' + quotes[i].text + '&nbsp;&rdquo;</p>';
            }
          }
          content_for("#freebase_quotes", output);
        }
      }

      //links

      output = '<h1>Elsewhere on the web</h1>';

      if (res.url)
      output += '<p class="linklist"><image src="' + images_url + 'misc/freebase.gif" alt="Freebase"> <a href="' + res.url + '" target="new">Freebase</a></p>';

      if (wikipedia_url)
      output += '<p class="linklist"><image src="' + images_url + 'misc/wikipedia.gif" alt="Wikipedia"> <a href="' + wikipedia_url + '" target="new">Wikipedia</a></p>';

      if (res.webpage) {
        for (var i=0; i < res.webpage.length; i++) {
          if (res.webpage[i].text && res.webpage[i].text.toLocaleLowerCase() != 'wikipedia') {
            output += '<p class="linklist"><a href="' + res.webpage[i].url + '" target="new">' + res.webpage[i].text + '</a></p>';
          }
        }
      }

      content_for("#freebase_links", output);
    }
  }

    function content_for(a) {
      text = '';
      if (arguments.length > 1) text = arguments[1];

//      $(arguments[0]).html(text);
      jQuery(arguments[0]).html(text);
    }
}
