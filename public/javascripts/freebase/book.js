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
    content_for("#freebase_details");
    content_for("#freebase_links");
    content_for("#freebase_quotes");
    content_for("#freebase_universe");
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

        //details section
        output = "";

        //date of first publication
        output += make_text(res.properties['/book/written_work/date_of_first_publication'], 'Date of first publication', ', ');

        //original language
        output += make_text(res.properties['/book/written_work/original_language'], 'Original language', ', ');

        //number of pages
        output += make_text(res.properties['/book/book_edition/number_of_pages'], 'Number of pages', ', ');

        content_for("#freebase_details", output);

        //quotes
        make_quotes(res.properties['/media_common/quotation_source/quotations']);

        //fictional universe
        output = '';
        output += make_text(res.properties['/fictional_universe/work_of_fiction/part_of_these_fictional_universes'], 'Part of universe', ', ');
        output += make_text([res.properties['/fictional_universe/fictional_universe/characters'], res.properties['/book/book/characters']], 'Characters', ', ');
        output += make_text([res.properties['/fictional_universe/work_of_fiction/setting'], res.properties['/fictional_universe/fictional_universe/locations'] ], 'Settings & locations', ', ');
        output += make_text(res.properties['/fictional_universe/fictional_universe/species'], 'Species', ', ');
        output += make_text(res.properties['/fictional_universe/fictional_universe/fictional_objects'], 'Fictional objects', ', ');
        output += make_text(res.properties['/fictional_universe/fictional_universe/languages'], 'Languages', ', ');

        if (output != '') {
          content_for("#freebase_universe", '<h1>Book universe</h1>' + output);
        }
      }

      //links
      make_links(res.url, wikipedia_url, res.webpage);
    }
  }
}
