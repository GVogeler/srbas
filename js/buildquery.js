/* Baut aus einem Formuler einen GAMS-Sparql-Parameter:
$1|param1;$2|param2

param1 = Suchstichw�rter 
param2 ein SPARQL-Ausdruck, der die Suchstichw�rter und einen Constraint enth�lt: Z.B. 

       # FILTER(regex(?text,"...","i")) # Regul�rer Ausdruck
       # FILTER(regex(?text,"...1","i") && regex(?text, "...2", "i")) #  Regul�rer Ausdruck auf einzelne W�rter
       # ?text bds:search "..." ;
       #    bds:matchAllTerms "true" . # Volltextsuche mit und-Verkn�pfung
       # ??? Volltextsuche mit nicht-Verkn�pfung
       # ??? Volltextsuche mit komplexer Syntax: oder/und/nicht kombiniert
       # FILTER(?jahr <= .... && ?jahr >= ...) # Zeitliche Einschr�nkung
       # ?konto bk:account <... Konto ...> . # Einschr�nkung auf Konto (incl. Unterkonten)
       # ??? Liste von Konten
       # FILTER(?betrag >= ...) # wobei der Vergleichsoperator mit �bergeben wird

Das Formular enth�lt
input["Stichwort"]
input["Suchart"] ('regex' oder 'fulltext')
?? verkn�pfung der Suchausdr�cke: alle "und", alle "oder", individuell?
input["jahrVor"], input["jahrNach"]
input["konto"] : SELECT-Liste mit Kontoname (Kontopfad) => Konto-URI
input["betrag"], input["betragsoperator"]

input["params"].hidden


Problem:
Ein String mit ? und & wird als explizite Parameter ausgewertet

Derzeit wird

http://gams.uni-graz.at/archive/objects/query:srbas.search/methods/sdef:Query/getXML?params=$1|jarlon zunfftmeister;$2|%3Ftext bds:search "jarlon zunfftmeister" ; bds:matchAllTerms "true" . FILTER(%3Fjahr <= 1580 %26%26 %3Fjahr >= 1545) %3Fentry bk:account <http://gams.uni-graz.at/rem/%23bs_Ausgaben> . 

gebaut, das als direkter Link nicht richtig ausgewertet wird.

%3F = ?
%26 = &
%24 = $

http://gams.uni-graz.at/archive/objects/query:srbas.search/methods/sdef:Query/getXML?params=$1|jarlon zunfftmeister;$2|?text bds:search "jarlon zunfftmeister" ; bds:matchAllTerms "true" . FILTER(?jahr <= 1580 && ?jahr >= 1545) ?entry bk:account <http://gams.uni-graz.at/rem/%23bs_Ausgaben> . 

http://gams.uni-graz.at/archive/objects/query:srbas.search/methods/sdef:Query/getXML?params=$1|jarlon zunfftmeister;$2|?text bds:search "jarlon zunfftmeister" ; bds:matchAllTerms "true" .

Maskierung von Suchanfragen
+ => %2b

Problem mit Regex-Maskierung: SESAME erwartet \\ ?

*/
function addParamsExt(me) {
	/* me ist das aktuelle Formular, da es auf einer Seite mehrere Formulare geben kann */
		/* Es mu� dann die Verarbeitung der $2-Parameter folgen */
		var Stichwoerter = searchTerms(me.Stichwort.value) ; /* Gibt einen Array aus Stichw�rtern und Operatoren zur�ck */
		//alert(Stichwoerter['Stichwoerter'][0]);
		/* Hier aus den Stichw�rtern und Operatoren je nach Suchart einen einschl�gigen Suchstring bilden: */
		var param2 = new String() ;
		if(me.Suchart.value == 'fulltext') { // FixMe: Das gilt nur wenn es nicht unterschiedliche Operatoren gibt, sonst mu� ich gruppieren ...
			param2 += "?text bds:search " + '"' + me.Stichwort.value + '" .';
			param2 += '?text bds:matchAllTerms "true" .'  ; //FixMe: Hier einen Oder-Parameter als "false" �bernehmen 
		}
		else if(me.Suchart.value == 'regex') {
			/* regex-Ausdr�cke maskieren?
			\ => %5C ??? Wie wird das durch die Verarbeitungskette gereicht?
			' und " maskieren?
			*/
			param2 += " FILTER(" ;
			for(i = 0; i < Stichwoerter['Stichwoerter'].length; i++){
				if(i > 0) {
					param2 +=' %26%26 '; //FixMe: Das mu� ggf. den Operatoren angepa�t werden
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
	   if(me.jahrVor.value != '' || me.jahrNach.value != '') {
	   	   // FILTER(?jahr <= .... && ?jahr >= ...) # Zeitliche Einschr�nkung
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
	   if(me.konto.value != '') {
	   	   param2 +=' %3Fentry bk:account ' + me.konto.value + ' . ' //  # Einschr�nkung auf Konto (incl. Unterkonten)
	   	   /* FixMe: bk:account oder bk:path?
	   	   bk:account hat keinen Toplevel, daf�r ein sauberer Graph.
	   	   bk:path ist Volltext und damit potentiell langsamer, damit ich mit einer rechts trunkierten Suche alles erwischen kann
	   	   Alle: /*
	   	   Konto: path* 
	   	   
	   	          ?text bds:search "jarlon zunfftmeister" ; 
      		bds:matchAllTerms "true" . 
    	?entry bk:mainAccount ?konto .
    ?konto bk:accountPath ?pfad .
      ?pfad bds:search "/*" .

	   	   */ 
	   	   // ??? Liste von Konten
	   }
	   if(me.betrag.value != '') {
	   	   /* FixMe: Betrag mit auf negative und positive Werte neutralisieren! */
	   	   param2 += ' FILTER(%3Fbetrag ' + me.betragsoperator.value + ' ' + me.betrag.value + ')'; // # W�hrungsumrechnungen mit ber�ckichtigen? 
	   	   // FixMe: Sicherstellen, da� betrag eine Zahl ist
	   	   //ToDo: betragsoperatoren wie "zwischen" und "ca" ( > x*0.95 && < )x*1.05 auswerten
	   }
		
		
		me.params.value="%241|" + me.Stichwort.value + ";%242|" + param2 ;
		alert("http://gams.uni-graz.at/archive/objects/query:srbas.search/methods/sdef:Query/getXML?params=" + me.params.value) ; //Debug
		me.Stichwort.setAttribute("disabled", "disabled");
		return true;
	
}

/* Ein Objekt mit den ganzen Funktionen? */

function searchTerms(stichwort) {
	// alert("Stichwort:" + stichwort);
	/* gibt einen Array der Stichw�rter und der Operatoren zur�ck */
	var result = new Array() ;
	/* Die Stichwoerter: */
	var Stichwoerter= stichwort.split(" ");
	/* und noch die Operatoren extrahieren, d.h. einleitende Zeichen, wenn sie + = und, - = nicht oder | = oder sind: */
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