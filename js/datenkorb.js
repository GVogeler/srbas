var db = new Databasket() ;
$(document).ready(function() { 
    console.log ( "======  Debug: Zurücksetzen des LocalStorage ========" );
    db.empty() ;
    console.log ( db.db ) ;
    console.log ( localStorage['srbasket'] ) ;
    console.log ( "ToDo: db.empty auf einen Button im Datenkorb legen ") ;
    console.log ( "==============" );
    $("#entries").on('change',function(evt) {
        /* evt = Kontext des Events */
        var me = $(evt.target) ;
        if ( me.hasClass('select_entry') ) {
/*            console.log ( me.prop('checked') ) ;*/
            if(me.prop('checked')) {
                console.log ( "add" ) ;
                var par = $(me.closest(".entry")) ;
/*                console.log ( $(me).closest(".entry") ) ;*/
                db.addEntry(par.attr('data-uri'),par.attr('data-type'), par.attr('data-account'), par.attr('data-amount'), par.attr('data-unit'));
            }
            else {
                console.log ( "delete" ) ;
                var par = $(me.closest(".entry")) ;
/*                console.log ( $(me).closest(".entry") ) ;*/
                db.deleteEntry(par.attr('data-uri'));
            }
        }
        db.saveToLocalStorage () ;
/*        $(Datenkorb-Werte).wert = db.getSum() ;*/
/*        console.log ( db.db );*/
/*        console.log ( localStorage['srbasket'] ) ;*/
        /* Berechne die Anzeige */
            var summenHTML = "" ;
            var summe = 0 ;
            summe= db.sum() ;
            summenHTML = summenHTML + "<p>Gesamtsumme: " + summe + "</p>" ;
            /*summe = parseAndSum($('p'),'bk:total') + parseAndSum($('p'),'bk:total') ;
            summenHTML = summenHTML + "<p>Summensumme: " + summe + "</p>" ;*/
            $("#calculations").html(summenHTML);
    }) ;
});

function Databasket() {
    /* Methoden:
        addEntry
        deleteEntry
        read-from-local-storage
        save-to-local-storage
        
       Werte:
        Liste von Objekten mit den Daten aus .entry-HTML-Elementen
            id="d2e250" 
            data-uri="http://glossa.uni-graz.at/archive/get/o:srbas.1535/sdef:TEI/get#d2e250"
            data-type="#bk_entry" 
            data-account="/bs_Einnahmen/bs_StadtEinnahmen/bs_Mühlenungeld" 
            data-amount="0" 
            data-unit="d."
            data-account-uri="http://gams.uni-graz.at/rem/#bs_..."
            data-jahr="1535"
            
            ToDo: account-uri und jahr noch übernehmen
    */
    
    /* Methoden:*/
        this.addEntry = function (uri, type, account, amount, unit) {
             var data = { 
                "uri" : uri, 
                "type": type, 
                "account": account, 
                "amount": amount,
                "unit": unit
                }
             this.db[uri]= data ;
        } ;
        
        this.deleteEntry = function (uri) {
/*            console.log ( "delete " + uri ) ;*/
            delete this.db[uri] ;
        } ;
        
        this.empty = function () {
            localStorage.removeItem('srbasket') ;
            /* ... ToDo: und dann noch das db-Objekt zurücksetzen */
       }
        
        this.readFromLocalStorage = function () {
            if (localStorage['srbasket']) {
                this.db = JSON.parse(localStorage['srbasket']) ;
             }
        } ;
        this.saveToLocalStorage = function () {
            localStorage['srbasket'] = JSON.stringify( this.db ) ;            
        } ;
        
        this.sum = function ()  {
            /* Übernimm das aus bookkeeping.parseAndSum etc. */
/*            console.log ( this ) ;*/
            $(this).each(function() {
/*                console.log ( this.id ) ;*/
            }
            );
        }

    this.db = {};
    this.readFromLocalStorage () ;
    Object.keys(this.db).forEach(function(key) {
/*        console.log ($("*[data-uri='" + key + "']"));*/
        $("*[data-uri='" + key + "']").find('input:checkbox.checkAll').attr('checked',true );
    })
/*    console.log ( Object.keys(this.db) ) ;*/
}

