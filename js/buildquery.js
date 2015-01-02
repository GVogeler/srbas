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

       
*/
function addParams(me) {
	/* me ist das aktuelle Formular, da es auf einer Seite mehrere Formulare geben kann */
	
		/* Es muß dann die Verarbeitung der $2-Parameter folgen */
		var Stichwoerter = searchTerms(me.Stichwort.value) ; /* Gibt einen Array aus Stichwörtern und Operatoren zurück */
		/* Hier aus den Stichwörtern und Operatoren je nach Suchart einen einschlägigen Suchstring bilden: */
		var param2 = new String() ;
		if(me.Suchart.value == 'fulltext') { // FixMe: Das gilt nur wenn es nicht unterschiedliche Operatoren gibt, sonst muß ich gruppieren ...
			param2 += "?text bds:search " + '"' + me.Stichwort.value + '" ;"';
			param2 += ' bds:matchAllTerms "true" .'  ; //FixMe: Hier einen Oder-Parameter als "false" übernehmen 
		}
		else if(me.Suchart.value == 'regex') {
			/* regex-Ausdrücke maskieren?
			\ => %5C ??? Wie wird das durch die Verarbeitungskette gereicht?
			' und " maskieren?
			*/
			param2 += "FILTER(" ;
			for(i = 0; i < Stichwoerter.length; i++){
				param2 +='regex(?text,"'+ Stichwoerter[i] +'","i")';
				if(i > 0) {
					params +=' && '; //FixMe: Das muß ggf. den Operatoren angepaßt werden
				}
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
	   	   // FILTER(?jahr <= .... && ?jahr >= ...) # Zeitliche Einschränkung
	   	   param2 += 'FILTER(' ;
	   	   if(me.jahrVor.value !='') {
	   	   	   param2 += '?jahr <= '+ me.jahrVor.value ;
	   	   }
	   	   if(me.jahrVor.value !='' && me.jahrNach.value != '') {
			   if(me.jahrVor.value > me.jahrNach.value) {
				   param2 +=' && ' ;
			   }
			   else {
				   param2 +=' || ' ;
			   }
		   }
	   	   if(me.jahrNach.value !='') {
	   	   	   param2 += '?jahr >= '+ me.jahrNach.value ;
	   	   }
	   	   param2 +=')';
	   }
	   if(me.kontoNach.value != '') {
	   	   param2 +=' ?konto bk:account ' + me.konto.value + ' . ' //  # Einschränkung auf Konto (incl. Unterkonten)
	   	   // ??? Liste von Konten
	   }
	   if(me.betrag.value != '') {
	   	   param2 += 'FILTER(?betrag ' + me.betragsoperator.value + ' ' + me.betrag + ')'; // # Währungsumrechnungen mit berückichtigen? 
	   	   // FixMe: Sicherstellen, daß betrag eine Zahl ist
	   	   //ToDo: betragsoperatoren wie "zwischen" und "ca" ( > x*0.95 && < )x*1.05 auswerten
	   }
		
		
		me.params.value="$1|" + me.Stichwort.value + ";$2|" + param2 ;
		alert(me.params.value) ; //Debug
		me.Stichwort.setAttribute("disabled", "disabled");
		return true;
	
}
/* Ein Objekt mit den ganzen Funktionen? */
function searchTerms(stichwort) {
	/* gibt einen Array der Stichwörter und der Operatoren zurück */
	var result = new Array() ;
	/* Die Stichwoerter: */
	var Stichwoerter= stichwort.split(" ");
	/* und noch die Operatoren extrahieren, d.h. einleitende Zeichen, wenn sie + = und, - = nicht oder | = oder sind: */
	var operators = new Array() ;
	for(i = 0; i < Stichwoerter.length; i++){
		if(Stichwoerter.chartAt(0).search("[+-|]") {
			operators[i] = Stichwoerter.chartAt(0) ;
			Stichwoerter[i] = Stichwoerter[i].susbstr(1) ; 
		}
		else {
			operators[i] = "+" ;
		}
	}
	result['Stichwoerter'] = Stichwoerter ;
	result['operators'] = operators ;
	return result ;
}