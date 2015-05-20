$(document).ready(function () {
    $('.check_group').click(function (event) {
        //on click
        var group = $(this.closest(".group"));
        var inputs = $(group).find(".case");
        if (this.checked) {
            // check select status            
            $(inputs).each(function () {
                //loop through each checkbox
                this.checked = true; //select all checkboxes with class "case"
/*                console.log ( "add-ms" ) ;*/
                var par = $(this.closest(".entry")) ;
                if ( par.attr('data-uri') ) {db.addEntry(par.attr('data-uri'),par.attr('data-type'), par.attr('data-account'), par.attr('data-amount'), par.attr('data-unit'), par.attr('data-year'), $(par[0].innerHTML)[2].textContent.trim());}
            });
        } else {
            $(inputs).each(function () {
                //loop through each checkbox
                this.checked = false; //deselect all checkboxes with class "checkbox1"
/*                console.log ( "delete-ms" ) ;*/
                var par = $(this.closest(".entry")) ;
                if ( par.attr('data-uri') ) { db.deleteEntry(par.attr('data-uri'));}
            });
        }
        db.saveToLocalStorage () ;
    });
});
