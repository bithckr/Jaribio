// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_self
//= require_tree .
//

function enable_execution_for_case(case_id) {
  $('div[id="case_' + case_id + '"] input:radio').removeAttr('disabled');
  $('div[id="case_' + case_id + '"] textarea').removeAttr('disabled');
  $('div[id="case_' + case_id + '"] input:submit').removeAttr('disabled');
  toggle_case_details(case_id);
}
function toggle_case_details(case_id) {
  $('div[id="case_' + case_id + '"] .case-details').slideToggle('slow', function() {
    // Animation complete.
  });
}
$(document).ready(function() {
  $('#copy-text').click(function(event) {
    var text = $('#copy-text').attr('text');
    window.prompt('Copy this text', text);
    event.preventDefault(); // Prevent link from following its href
  });
});

