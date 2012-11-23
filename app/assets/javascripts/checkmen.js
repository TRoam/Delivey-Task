$(document).ready(function(){
  $('#checkmen').dataTable()
    sPaginationType: "full_numbers"
    bJQueryUI: true
   
  $(".flip").click(function(){
    $("div.Import_help").slideToggle("slow");
    $("#create_form").slideToggle("slow");
  });
  $("#search").click(function() {
     $(this).hide();
     $("#search_form").slideDown();
  });
  $("div.action").click(function(){
    $("#search_form").slideUp();
    $("#search").show();
  })
  $("h1>a").click(function() {
    $("#main_body").load(this.href);
  });
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
  $("form>div.actions").click(function(){
    $("#create_form").slideUp(function(){
      alert("Create successful!");
    });
  });
  $("table").css('padding-right','60')
 })

