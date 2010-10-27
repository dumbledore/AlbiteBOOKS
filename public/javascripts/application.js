// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var searchLabel = "Search for books...";

function doc_load() {
  document.getElementById('search_text').value = searchLabel;
//  new Autocomplete('search_text', { serviceUrl:'/autocomplete/' });
}

function focus_on_load(item) {
  document.getElementById(item).focus();
}

function search_blur(o) {
  if (o.value == '')
    o.value = searchLabel;
  o.style.color = 'AAAAAA';
}

function search_focus(o) {
  if (o.value == searchLabel)
    o.value = '';
  o.style.color = '606060';
}

function imposeMaxLength(Object, MaxLen)
{
  if (Object.value.length > MaxLen)
    Object.value = Object.value.substring(0, MaxLen)
}
