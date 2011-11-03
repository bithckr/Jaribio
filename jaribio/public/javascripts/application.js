function enable_execution_for_case(case_id) {
  $('div[id="case_' + case_id + '"] input:radio').removeAttr('disabled');
}
function toggle_case_details(case_id) {
  $('div[id="case_' + case_id + '"] .case-details').slideToggle('slow', function() {
    // Animation complete.
  });
}
