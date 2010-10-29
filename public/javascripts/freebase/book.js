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

        //details section
        output = "";

        //date of first publication
        output += make_text(res.properties['/book/written_work/date_of_first_publication'], 'Date of first publication', ', ');

        //original language
        output += make_text(res.properties['/book/written_work/original_language'], 'Original language', ', ');

        content_for("#freebase_details", output);

        //quotes
        make_quotes(res.properties['/media_common/quotation_source/quotations']);
      }

      //links
      make_links(res.url, wikipedia_url, res.webpage);
    }
  }
}
