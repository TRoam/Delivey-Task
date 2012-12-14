$(document).ready(function(){
  // live event for every td ,and once click it ,the detial information will display
  $("#checkmen tbody>tr").live(
    'click',
    function(){
        $(this).find("a:last").trigger('click');
    }
    )
  //send mail to 
 // manual_mail send 
 // make the right side donn't move with the main div
//create component and improt
  $("#component-import").width(80).click(function(){
    $("#component-import-form").slideToggle();
  })
  $("#component-create-button").width(80).click(function(){
    $("#create_form").slideToggle();
   });
  //close person edit
  //close item_detail imformation
  //close the comment
  $("#comment_area").find(".close").live(
        'click',
         function(event){
            $("#item-detail").empty();
            $(this).parent().hide();
            var tableid = '#' + $(this).attr("id");
            $("#checkmen").find(tableid).css('background','');
  })
  // Table format --with DATATABLE
  $('#checkmen').dataTable({
    // "bJQueryUI": true,
    "bProcessing": true,
    // "bServerSide": true,
    "sScrollX": "100%",
    "bStateSave": true,
    "bScrollCollapse": true,
     "iCookieDuration": 60*60*24,
    // "bSortCellsTop": false,
    "sZeroRecords": "Nothing found - sorry",
    // "sScrollY": "400",
    // "bScrollCollapse": true,
    "sPaginationType": "full_numbers"
  });
  // left-side self-adaption and the scroll
   var height = $(window).height();
   $("#left-side").height(height)
  // search and filter toggle
  $("#search").width(80).click(function() {
     $("#search_form").slideToggle("fast");
  });
  $("#new_import").width(80).click(function(){
      $("#import_body").slideToggle("fast");
  });
  // Ajax load action
  $("h1>a").click(function() {
  $("#main_body").load(this.href);
  }); 
  // serch form add fields and remove fields
   $('form').on('click', '.remove_fields', function(event) {
    $(this).closest('.field').remove();
    return event.preventDefault();
  });
  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });
  // menu highlight
    var myNav=$(".nav a");
    var currentlink = window.location.href;
    for (var i = 0; i <myNav.length; i++) {
      if (currentlink.indexOf($(myNav[i]).attr("href")) != -1 ){
        $(myNav[i]).parent().addClass("active");
        return;
      };
    };
    $(myNav[0]).parent().addClass("active");
   $("#search").popover("show");
 })