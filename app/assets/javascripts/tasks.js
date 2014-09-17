// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  
  $('#tasks').sortable(
    {
      axis: 'y',
      handle: '.handle',
      update: function() {
        return $.post($(this).data('update-url'), $(this).sortable('serialize'));
      }
    });
  
  
});
