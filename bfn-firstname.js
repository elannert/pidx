$(document).ready(function(){
  if($('body').attr('id') != 'app') {
    var textbox = $('#sgE-3533844-3-6-element');  //name box  
    
    textbox.change(function(){
      var firstname = $(this).val();
      console.log(firstname);
      var newval = '=vlookup("' + firstname + '", \'Firstnames Returning\'!A:C,2,false)';
      console.log(newval);
      var tgtbox = $('#sgE-3533844-3-39-element'); //formula box
      tgtbox.val(newval);
    
    });
  }
});

/*
$(document).ready(function(){
  if($('body').attr('id') != 'app') {
  
    var textbox = $('#sgE-3536220-1-5-element');  //name box  
    //var textbox = $('.bfn-firstname');  //name box  
    //console.log(textbox);
    
    textbox.change(function(){
      var firstname = $(this).val();
      //console.log($(this));
      console.log('t.change val ' + firstname);

      var newval = '=vlookup("' + firstname + '", \'Firstnames Returning\'!A:C,2,false)';
      console.log('formula: ' + newval);
      //var newval= "yest";     
      var tgtbox = $('#sgE-3536220-1-8-element'); //formula box
      //console.log(tgtbox);
      tgtbox.val(newval);
    
    });
  }
});
*/