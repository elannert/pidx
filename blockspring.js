var blockspring = require('blockspring');

blockspring.define(function(request, response) {
    
    var bfnid = request.params["bfnid"];
    if (bfnid) {
        var query = "SELECT B where A = " + bfnid;

        blockspring.runParsed("query-google-spreadsheet", { 
            "query": query,
            "url": "https://docs.google.com/spreadsheets/d/1oCyvhgKQGTORho4XeNmNKoKjvu3OCQTr4mS_BKbbL00/edit#gid=0" 
        }, { cache: true, expiry: 7200}, function(res) {
            
            try{
                var name = res.params.data[0].name;
                response.addOutput('data', res.params.data);
                
                //response.addOutput('name', "Is your child's name: " + name);
                response.addOutput('name', name);
                
                response.end();
            } catch (err) {
                response.addOutput('name', "Sorry, we were not able to find that Badge ID number. Please try again or contact us.");
                response.end();
            }
        });

        
    } else {
        response.addOutput('no id supplied');
        response.end();

    }
        
    
    
	
});

//https://run.blockspring.com/api_v2/blocks/678080f2afec81da785166dfe5aa4ee3?api_key=br_60423_0fe4388456610d564c06b3e6a9f9145bc887b61f
