var db = new Databasket() ;
/*console.log ( "======  Debug: Zurücksetzen des LocalStorage ========" );*/
/*db.empty() ;*/
/*console.log ( db.db ) ;*/
/*console.log ( localStorage['srbasket'] ) ;*/
console.log ( "ToDo: db.empty auf einen Button im Datenkorb legen ") ;
/* ToDo: Zu ersetzen durch Laden des LocalStorage und Anzeige der entsprechenden Inputs (evtl. über selectMultiple.js?)*/
console.log ( "==============" );
$(document).ready(function() { 
    $("#entries").on('change',function(evt) {
        /* evt = Kontext des Events */
        var me = $(evt.target) ;
        if ( me.hasClass('select_entry') ) {
/*            console.log ( me.prop('checked') ) ;*/
            if(me.prop('checked')) {
                console.log ( "add" ) ;
                var par = $(me.closest(".entry")) ;
/* FixMe: Add/Delete-Aktionen mit Speichern werden auch in multipleSelect verwendet - kann ich das vereinfachen? */
                db.addEntry(par.attr('data-uri'),par.attr('data-type'), par.attr('data-account'), par.attr('data-amount'), par.attr('data-unit'), par.attr('data-year'), $(par[0].innerHTML)[2].textContent.trim());
            }
            else {
                console.log ( "delete" ) ;
                var par = $(me.closest(".entry")) ;
                db.deleteEntry(par.attr('data-uri'));
            }
        }
        db.saveToLocalStorage () ;
        console.log ( db.db );
        /* console.log ( localStorage['srbasket'] ) ;*/
        /* Berechne die Anzeige */
        db.showTotals() ;
    }) ;
    db.showTotals() ;
});

function Databasket() {
    /* Methoden:
        addEntry
        deleteEntry
        read-from-local-storage
        save-to-local-storage
        sum (Teil- bzw. Gesamtsummen ziehen)
        showTotals (im Datenkorb)
        
       Werte:
        Liste von Objekten mit den Daten aus .entry-HTML-Elementen
            id="d2e250" 
            data-uri="http://glossa.uni-graz.at/archive/get/o:srbas.1535/sdef:TEI/get#d2e250"
            data-type="#bk_entry" 
            data-account="/bs_Einnahmen/bs_StadtEinnahmen/bs_Mühlenungeld" 
            data-amount="0" 
            data-unit="d."
            data-account-uri="http://gams.uni-graz.at/rem/#bs_..."
            data-year="1535"
            Text? = 
            
            ToDo: account-uri und jahr noch übernehmen
    */
    
    /* Methoden:*/
        this.addEntry = function (uri, type, account, amount, unit, jahr, text) {
             var data = { 
                "uri" : uri, 
                "type": type, 
                "account": account, 
                "amount": amount,
                "unit": unit,
                "year": jahr,
                "text": text
                }
             this.db[uri]= data ;
        } ;
        
        this.deleteEntry = function (uri) {
/*            console.log ( "delete " + uri ) ;*/
            delete this.db[uri] ;
        } ;
        
        this.empty = function () {
            localStorage.removeItem('srbasket') ;
            this.db = {};
       }
        
        this.readFromLocalStorage = function () {
            if (localStorage['srbasket']) {
                this.db = JSON.parse(localStorage['srbasket']) ;
             }
        } ;
        this.saveToLocalStorage = function () {
            localStorage['srbasket'] = JSON.stringify( this.db ) ;            
        } ;
        
        /* Summen ziehen */
        this.sum = function (year)  {
            year = typeof year !== 'undefined' ? year : 0; //0 = alle
            /* ToDo: Auswahl, ob Summen nach Jahren oder Konten gezogen wird */
            /*  console.log ( "Summierung: " + year );*/
            var sum = 0 ;
            $.each(this.db, function(index, value) {
                if(value['year'] == year || year == 0) {
                    sum+=parseFloat(value['amount']) || 0;
                }
              }
            );
            return sum ;
        }
        
        /* gezogene Summen in Text umwandeln */
        this.showTotals = function () {
            var summenHTML = "" ;
            /* Teilsummen nach Jahren: */
            var jahre = {} ;
            $.each(this.db, function(index, value) {
                    jahre[value['year']] = 0;
                }
            );
            /* Die Jahresangaben müssen numerisch sortiert sein bevor für jedes eine Zeile geschrieben wird */
            arr_jahre = [], arr_jahre.length = 0 ;
            for (var jahr in jahre) {
                arr_jahre.push(parseInt(jahr)) ;
             }
            arr_jahre.sort() ;
            for (i = 0; jahr = arr_jahre[i], i < arr_jahre.length; i++) {
                summenHTML += '<tr class="datenkorb jahr"><td>' + jahr + "/" + (parseInt(jahr) + 1) + ':</td><td class="datenkorb betrag">' + this.sum(jahr) + " d.</td></tr>" ;
            }
            summenHTML += '<tr class="datenkorb gesamt"><td>Gesamt:</td><td class="datenkorb betrag">' + this.sum() + " d.</td></tr>" ;
            summenHTML = '<table class="datenkorb">' + summenHTML + "</table>" ;
            $("#calculations").html(summenHTML);
        }

    this.db = {};
    this.readFromLocalStorage () ;
    Object.keys(this.db).forEach(function(key) {
        $("*[data-uri='" + key + "']").find('input:checkbox.select_entry').attr('checked',true );
    }) //Checkboxen nach Datenkorb anwählen
    this.showTotals() ; //Summen als Datenkorbinhalt
}

