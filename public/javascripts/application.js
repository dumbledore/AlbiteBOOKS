// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var searchLabel = "Search for books and authors...";

function doc_load() {
  search_blur(document.getElementById('query'));
}

function focus_on_load(item) {
  document.getElementById(item).focus();
}

function search_blur(o) {
  if (o.value == '') {
    o.value = searchLabel;
  }
}

function search_focus(o) {
  if (o.value == searchLabel) {
    o.value = '';
  }
}

function imposeMaxLength(Object, MaxLen)
{
  if (Object.value.length > MaxLen)
    Object.value = Object.value.substring(0, MaxLen)
}
