/* Baut aus einem Formuler einen GAMS-Sparql-Parameter:
$1|param1;$2|param2

param1 = Suchstichwörter 
param2 ein SPARQL-Ausdruck, der die Suchstichwörter und einen Constraint enthält: Z.B. 

       # FILTER(regex(?text,"...","i")) # Regulärer Ausdruck
       # FILTER(regex(?text,"...1","i") && regex(?text, "...2", "i")) #  Regulärer Ausdruck auf einzelne Wörter
       # ?text bds:search "..." ;
       #    bds:matchAllTerms "true" . # Volltextsuche mit und-Verknüpfung
       # ??? Volltextsuche mit nicht-Verknüpfung
       # ??? Volltextsuche mit komplexer Syntax: oder/und/nicht kombiniert
       # FILTER(?jahr <= .... && ?jahr >= ...) # Zeitliche Einschränkung
       # ?konto bk:account <... Konto ...> . # Einschränkung auf Konto (incl. Unterkonten)
       # ??? Liste von Konten
       # FILTER(?betrag >= ...) # wobei der Vergleichsoperator mit übergeben wird

Das Formular enthält
input["Stichwort"]
input["Suchart"] ('regex' oder 'fulltext')
?? verknüpfung der Suchausdrücke: alle "und", alle "oder", individuell?
input["jahrVor"], input["jahrNach"]
input["konto"] : SELECT-Liste mit Kontoname (Kontopfad) => Konto-URI
input["betrag"], input["betragsoperator"]

input["params"].hidden



Maskierung von Suchanfragen
+ => %2b
%3F = ?
%26 = &
%24 = $

Problem mit Regex-Maskierung: SESAME erwartet \\ ?

*/
function addParamsExt(me) {
    /* TODO: Kontrolle, daß mindestens ein Suchbegriff übergeben wird: me.Stichwort.value darf nicht NULL sein, sonst ...?*/
	/* me ist das aktuelle Formular, da es auf einer Seite mehrere Formulare geben kann */
		/* Es muß dann die Verarbeitung der $2-Parameter folgen */
		var Stichwoerter = searchTerms(me.Stichwort.value) ; /* Gibt einen Array aus Stichwörtern (Stichwoerter['Stichwoerter'] oder Stichwoerter['operators']) zurück */
		//alert(Stichwoerter['Stichwoerter'][0]);
		/* Hier aus den Stichwörtern und Operatoren je nach Suchart einen einschlägigen Suchstring bilden: */
		var param2 = new String() ;
		if(me.Suchart.value == 'fulltext') { // FixMe: Das gilt nur wenn es nicht unterschiedliche Operatoren gibt, sonst muß ich gruppieren ...
			/* ToDo: 1. Alle Stichwörter ohne operators oder mit Plus als  operators */
			param2 += "%3Ftext bds:search " + '"' + me.Stichwort.value + '" .';
			param2 += '%3Ftext bds:matchAllTerms "true" .'  ;
			/* 2. Alle Stichwörter mit Minus (nicht) als operators */
			
			/* 3. Alle Stichwörter mit Strich (kann) als operators */
			
		}
		else if(me.Suchart.value == 'regex') {
			/* regex-Ausdrücke maskieren?
			\ => %5C ??? Wie wird das durch die Verarbeitungskette gereicht?
			' und " maskieren?
			*/
			param2 += " FILTER(" ;
			for(i = 0; i < Stichwoerter['Stichwoerter'].length; i++){
				if(i > 0) {
					param2 +=' %26%26 '; //FixMe: Das muß ggf. den Operatoren angepaßt werden
				}
				param2 +='regex(%3Ftext,"'+ encodeURIComponent('\\\\b' + Stichwoerter['Stichwoerter'][i] + '\\\\b') +'","i")';
			}
			param2 +=")" ;
		}
		/* Und jetzt noch die constraints aus
		input["jahrVor"], input["jahrNach"]
		input["konto"]
		input["betrag"]
		input["betragsoperator"]
		
		*/
	   // #### Zeitliche Einschränkung: FILTER(?jahr <= .... && ?jahr >= ...) 
	   if(me.jahrVor.value != '' || me.jahrNach.value != '') {
	   	   param2 += ' FILTER(' ;
	   	   if(me.jahrVor.value !='') {
	   	   	   param2 += '%3Fjahr <= '+ me.jahrVor.value ;
	   	   }
	   	   if(me.jahrVor.value !='' && me.jahrNach.value != '') {
			   if(me.jahrVor.value > me.jahrNach.value) {
				   param2 +=' %26%26 ' ;
			   }
			   else {
				   param2 +=' || ' ;
			   }
		   }
	   	   if(me.jahrNach.value !='') {
	   	   	   param2 += '%3Fjahr >= '+ me.jahrNach.value ;
	   	   }
	   	   param2 +=')';
	   }
	   //  # Einschränkung auf Konto (incl. Unterkonten)	   
	   if(me.konto.value != '') {
	   	   param2 +=' %3Fentry bk:account ' + me.konto.value + ' . ' ;
	   }
	   // # Einschränkung nach Beträgen
	   if(me.betrag.value != '') {
          // Sicherstellen, daß betrag eine Zahl ist
          if(me.betragsoperator.value == 'zwischen') {
          //betragsoperator "zwischen" auswerten:
          /* Syntax: Zahl irgendwas Zahl */
              var zwischen = /\b([0-9,.]+)\b.+\b([0-9,.]+)\b/;
              var betraege = zwischen.exec(me.betrag.value) ;
              param2 +=' FILTER(abs(%3Fbetrag) >= ' + betraege[1] + ' %26%26 abs(%3Fbetrag) <= ' + betraege[2] + ' )' ;
          }
          else if(Math.abs(Number(me.betrag.value)) > 0) {
              if(me.betragsoperator.value =='circa') {
                param2 +=' FILTER(abs(%3Fbetrag) > ' + (Number(me.betrag.value) * 0.95) + ' %26%26 abs(%3Fbetrag) < ' + (Number(me.betrag.value) * 1.05) + ')'; // # Währungsumrechnungen mit berückichtigen?
              }
              else {
                param2 += ' FILTER(abs(%3Fbetrag) ' + me.betragsoperator.value + ' ' + me.betrag.value + ')'; // # Währungsumrechnungen mit berückichtigen?
              }
          }
          else {
            alert("Der Betrag '" + me.betrag.value + "' kann nur berücksichtigt werden, wenn er eine Zahl ist.");
          }
	   }
		
		// Und hier bauen wir das ganze zusammen und übergeben es
		me.params.value="%241|" + me.Stichwort.value + ";%242|" + param2 ;
		//alert("http://glossa.uni-graz.at/archive/objects/query:srbas.search/methods/sdef:Query/getXML?params=" + me.params.value); //Debug
        window.location.href="http://glossa.uni-graz.at/archive/objects/query:srbas.search/methods/sdef:Query/get?params=" + me.params.value;
        return false;	
}

/* Ein Objekt mit den ganzen Funktionen? */

function searchTerms(stichwort) {
	// alert("Stichwort:" + stichwort);
	/* gibt einen Array der Stichwörter und der Operatoren zurück */
	var result = new Array() ;
	/* Die Stichwoerter: */
	var Stichwoerter= stichwort.split(" ");
	/* und noch die Operatoren extrahieren, d.h. einleitende Zeichen wie folgt:
		+ = muß vorkommen 
		- = darf nicht vorkommen 
		| = kann vorkommen, muß aber nicht
	*/
	var operators = new Array() ;
	for(i = 0; i < Stichwoerter.length; i++){
		//alert("|"+Stichwoerter[i]+"|");
		if(Stichwoerter[i].charAt(0).search("[+-|]")) {
			operators[i] = Stichwoerter[i].charAt(0) ;
			Stichwoerter[i] = Stichwoerter[i].susbstr(1) ; 
		}
		else {
			operators[i] = "+" ;
		}
	}
	result['Stichwoerter'] = Stichwoerter ;
	result['operators'] = operators ;
	// alert(result['operators'][0]);
	return result ;
}