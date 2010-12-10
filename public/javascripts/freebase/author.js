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
    content_for("#freebase_quotes");
  }

  function displayResults(response) {

    clearAll();

    if (response[freebase_uid] && response[freebase_uid].code == "/api/status/ok" && response[freebase_uid].result) {
      var res = response[freebase_uid].result;
      var output = "";

      //wikipedia url
      wikipedia_url = get_wikipedia_url(res.webpage);

      //description
      if (res.description) {
        output += res.description;
        if (wikipedia_url) {
          output += ' <a href="' + wikipedia_url + '" target="new">more at Wikipedia</a>';
        }
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
          var born = [];
          if (res.properties['/people/person/date_of_birth']) {
            born.push(make_text(res.properties['/people/person/date_of_birth'], '', ', '));
          }
          if (res.properties['/people/person/place_of_birth']) {
            born.push(make_text(res.properties['/people/person/place_of_birth'], '', ', '));
          }
          output += '<p><strong>Born:</strong> ' + born.join(', ') + '</p>';
        }

        //died
        if (
                res.properties['/people/deceased_person/date_of_death'] ||
                res.properties['/people/deceased_person/place_of_death']
        )
        {
          var died = [];
          if (res.properties['/people/deceased_person/date_of_death']) {
            died.push(make_text(res.properties['/people/deceased_person/date_of_death'], '', ', '));
          }
          if (res.properties['/people/deceased_person/place_of_death']) {
            died.push(make_text(res.properties['/people/deceased_person/place_of_death'], '', ', '));
          }
          output += '<p><strong>Died:</strong> ' + died.join(', ') + '</p>';
        }

        //nationality
        output += make_text(res.properties['/people/person/nationality'], 'Country of nationality', ', ');

        //profession
        output += make_text(res.properties['/people/person/profession'], 'Worked as', ', ');

        content_for("#freebase_bio", output);

        //quotes
        make_quotes(res.properties['/people/person/quotations']);
      }

      //links
      make_links(res.url, wikipedia_url, res.webpage);
    }
  }
}
