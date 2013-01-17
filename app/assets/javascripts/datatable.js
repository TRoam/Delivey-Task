$(document).ready(function(){
	var oTable;
	//data table for overview
	oTable =$('#checkmen_result').dataTable({
			     // "sDom": 'RC<"clear">lfrtip',
			     "bSortCellsTop": true,
			      // "bJQueryUI": true,
			      // "sDom": "<'row'<'span8'l><'span8'f>r>t<'row'<'span8'i><'span8'p>>",
			      "sPaginationType": "bootstrap",
			      "bProcessing": true,
			      "bServerSide": true,
			      "bAutoWidth":false,
			      "sAjaxSource":$("#data").data("source"),
            // "sServerMethod": "POST",
			      // "bStateSave": true
			      "iDisplayLength":15,
			      "iCookieDuration": 60*60*24,
			      "bLengthChange": false,
			      "aoColumnDefs": [ { "bSortable": false, "aTargets": [ 0,7,8 ] },] ,
			      "sPaginationType": "full_numbers",
			      "oLanguage": {
			      "sSearch": "Search in checkmen:",
			      "sLoadingRecords": "Please wait - loading...",
			      "sZeroRecords": "--Cangratulations, No Checkmen error here!--"
			    }
			  }).columnFilter({
			  	   "sPlaceHolder": "head:before",
			  		"aoColumns":[
			  			null,
			  			{"type":"select",
			  			 "values":['open','Addressed'],
			  			},
			  			{"type":"text"},
			  			{"type":"text"},
			  			{"type":"text"},
			  			{"type":"select",
			  			 "values":[1,2,3,4],
			  			},
			  			{"type":"select",
			  			 "values":['V7Z','EXC','C6Z'],
			  			},
			  			{"type":"text"},
			  			{"type":"text"},
			  			{"type":"text"},
			  			{"type":"select",
			  			 "values":['Prodrel'],
			  			},
			  		]
		});
    $("#status_select select").css("width","60px");
    $("#tfoot_input  input").css("width","120px");
    $("#tfoot_input_P  input").css("width","100px");
    $("div.dataTables_filter#checkmen_result_filter").hide();
  $(".person_edit").live(
    'click',
    function(){
      var nTr =$(this).parents('tr')[0];
      if (oTable.fnIsOpen(nTr))
        {
          oTable.fnClose(nTr);
        } 
      else
        {
          var person_edit_url = "/checkmen/"+$(this).attr("id")+ "/person_edit";
          $.get(person_edit_url);
        };
    }
    );
    // Table format --with DATATABLE
  $('#component').dataTable(
  {
      // "bJQueryUI": true,
    "bProcessing": true,
    "iDisplayLength":30,
    // "bServerSide": true,
    // "sScrollX": "100%",
    "bStateSave": true,
    "bAutoWidth": false,
    // "bScrollCollapse": true,
     "iCookieDuration": 60*60*24,
     "bLengthChange": false,
     "aoColumnDefs": [ { "bSortable": false, "aTargets": [ 0 ] }] ,
    // "bSortCellsTop": false,
    "sZeroRecords": "Nothing found - sorry",
    // "sScrollY": "400",
    // "bScrollCollapse": true,
    "sPaginationType": "full_numbers"
  });
  $('#package').dataTable(
  {
      // "bJQueryUI": true,
    "bProcessing": true,
    "iDisplayLength":30,
    // "bServerSide": true,
    "bStateSave": true,
    "bAutoWidth": false,
     "iCookieDuration": 60*60*24,
     "bLengthChange": false,
     "aoColumnDefs": [ { "bSortable": false, "aTargets": [ 0 ] }] ,
    // "bSortCellsTop": false,
    "sZeroRecords": "Nothing found - sorry",
    "sPaginationType": "full_numbers"
  });
    // other tables (component ,package,)
    $('#checkmen').dataTable({
      // "bJQueryUI": true,
      "bProcessing": true,
      "iDisplayLength":20,
      // "bServerSide": true,
      "bStateSave": true,
      "bAutoWidth": false,
      "iCookieDuration": 60*60*24,
      "bLengthChange": false,
      // "aoColumnDefs": [ { "bSortable": false, "aTargets": [ 0 ] }] ,
      // "bSortCellsTop": false,
      
      "sPaginationType": "full_numbers"
    });
  
})