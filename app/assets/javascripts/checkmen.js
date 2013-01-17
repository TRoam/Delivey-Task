//select all or unselectall
function toggle_checkall_result(field_name, state) {
  var checkboxes = $("#checkmen_result input")
  var count = checkboxes.length;
  for (var i = 0; i < count; i++) {
    if (checkboxes[i].type == "checkbox"
        && checkboxes[i].name == field_name + "_ids[]") {
      checkboxes[i].checked = state;
    }
  }
};
function toggle_checkall(field_name,state){
  var checkboxes = $("#package input")
  var count = checkboxes.length;
  for (var i = 0; i < count; i++) {
    if (checkboxes[i].type == "checkbox"
        && checkboxes[i].name == field_name + "_ids[]") {
      checkboxes[i].checked = state;
    }
  }
};


// toggle comments and detail checkman information

$(document).ready(function(){

   
  //mial Prodrel?
  $("#people_mail_button button:first").live(
    'click',
    function(){
      $(".mail_prodrel").trigger('click');
    }
    )
   $("#people_mail_button button:last").live(
    'click',
    function(){$(".mail_all").trigger('click');
  }
    )
  // live event for every td ,and once click it ,the detial information will display
  $(".display tbody>tr td:not('#check_box')").live(
    'click',
    function(){
      $(this).parent().find("a:last").trigger('click');
    }
    )
  // $("#checkmen tbody>tr td").live(
  //   'click',
  //   function(){
  //       $(this).parent().find("a:last").trigger('click');
  //       };
  //   }
  //   )
  $("#component-import").width(80).click(function(){
    $("#component-import-form").slideToggle();
  })
  $("#component-create-button").width(80).click(function(){
    $("#create_form").slideToggle();
   });
  //close person edit
  //close item_detail imformation
  //close the comment
  $("#commentmyModal").find(".close").live(
        'click',
         function(event){
            var tableid = '#' + $(this).attr("id");
            $("#checkmen").find(tableid).css('background','');
  })

  // left-side self-adaption and the scroll
   var height = $(window).height();
   $("#left-side").height(height)
  // search and filter toggle
  $("#search").width(80).click(function() {
     $("#search_form").slideToggle("fast");
  });
  $("#new_import").width(80);
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