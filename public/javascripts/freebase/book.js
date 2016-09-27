function freebase(freebase_uid) {

  if (!freebase_uid) {
    clearAll();
    return;
  }

  // Adding callback=? to the URL makes jQuery do JSONP instead of XHR.
  jQuery.getJSON(frebase_topic_url(freebase_uid), displayResults); // Callback function

  function clearAll() {
    content_for("#freebase_description");
    content_for("#freebase_details");
    content_for("#freebase_links");
    content_for("#freebase_quotes");
    content_for("#freebase_universe");
  }

  function displayResults(response) {
    var temp;

    clearAll();

    if (response['property']) {
      var res = response['property'];

      // general description
      fill_description(res);

      //details section
      var output = "";

      //date of first publication
      temp = get_detail(res, '/book/written_work/date_of_first_publication');
      if (temp) {
        output += make_text(temp, 'Date of first publication', ', ');
      }

      //original language
      temp = get_detail(res, '/book/written_work/original_language');
      if (temp) {
        output += make_text(temp, 'Original language', ', ');
      }

      //number of pages
      temp = get_detail(res, '/book/book_edition/number_of_pages');
      if (temp) {
        output += make_text(temp, 'Number of pages', ', ');
      }
      content_for("#freebase_details", output);

      //quotes
      make_quotes(res['/media_common/quotation_source/quotations']);

      //fictional universe
      output = '';
      output += make_text(res['/fictional_universe/work_of_fiction/part_of_these_fictional_universes'], 'Part of universe', ', ');
      output += make_text([res['/fictional_universe/fictional_universe/characters'], res['/book/book/characters']], 'Characters', ', ');
      output += make_text([res['/fictional_universe/work_of_fiction/setting'], res['/fictional_universe/fictional_universe/locations'] ], 'Settings & locations', ', ');
      output += make_text(res['/fictional_universe/fictional_universe/species'], 'Species', ', ');
      output += make_text(res['/fictional_universe/fictional_universe/fictional_objects'], 'Fictional objects', ', ');
      output += make_text(res['/fictional_universe/fictional_universe/languages'], 'Languages', ', ');

      if (output != '') {
        content_for("#freebase_universe", '<h1>Book universe</h1>' + output);
      }
    }
  }
}
