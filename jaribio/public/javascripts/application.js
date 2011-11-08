function enable_execution_for_case(case_id) {
  $('div[id="case_' + case_id + '"] input:radio').removeAttr('disabled');
  $('div[id="case_' + case_id + '"] textarea').removeAttr('disabled');
  $('div[id="case_' + case_id + '"] input:submit').removeAttr('disabled');
  $('div[id="case_' + case_id + '"] button').attr('disabled', 'disabled');
}
function toggle_case_details(case_id) {
  $('div[id="case_' + case_id + '"] .case-details').slideToggle('slow', function() {
    // Animation complete.
  });
}
