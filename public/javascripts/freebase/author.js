function freebase(freebase_uid) {

  if (!freebase_uid) {
    clearAll();
    return;
  }

  // Adding callback=? to the URL makes jQuery do JSONP instead of XHR.
  jQuery.getJSON(frebase_topic_url(freebase_uid), displayResults); // Callback function

  function clearAll() {
    content_for("#freebase_description");
    content_for("#freebase_bio");
    content_for("#freebase_links");
    content_for("#freebase_quotes");
  }

  function displayResults(response) {
    var temp1;
    var temp2;

    clearAll();

    if (response['property']) {
      var res = response['property'];

      // general description
      fill_description(res);

      //biography
      var output = "";

      //born
      temp1 = get_detail(res, '/people/person/date_of_birth');
      temp2 = get_detail(res, '/people/person/place_of_birth');
      if (temp1 || temp2) {
        var born = [];
        if (temp1) {
          born.push(temp1);
        }
        if (temp2) {
          born.push(temp2);
        }
        output += '<p><strong>Born:</strong> ' + born.join(', ') + '</p>';
      }

      //died
      temp1 = get_detail(res, '/people/deceased_person/date_of_death');
      temp2 = get_detail(res, '/people/deceased_person/place_of_death');
      if (temp1 || temp2) {
        var died = [];
        if (temp1) {
          died.push(temp1);
        }
        if (temp2) {
          died.push(temp2);
        }
        output += '<p><strong>Died:</strong> ' + died.join(', ') + '</p>';
      }

      //nationality
      temp1 = get_detail(res, '/people/person/nationality');
      if (temp1) {
        output += make_text(temp1, 'Country of nationality', ', ');
      }

      //profession
      temp1 = get_detail(res, '/people/person/profession');
      if (temp1) {
        output += make_text(temp1, 'Worked as', ', ');
      }
      content_for("#freebase_bio", output);

      //quotes
      make_quotes(res['/people/person/quotations']);
    }
  }
}
