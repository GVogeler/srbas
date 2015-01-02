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

       
*/
function addParams(me) {
	/* me ist das aktuelle Formular, da es auf einer Seite mehrere Formulare geben kann */
	
		/* Es mu� dann die Verarbeitung der $2-Parameter folgen */
		var Stichwoerter = searchTerms(me.Stichwort.value) ; /* Gibt einen Array aus Stichw�rtern und Operatoren zur�ck */
		/* Hier aus den Stichw�rtern und Operatoren je nach Suchart einen einschl�gigen Suchstring bilden: */
		var param2 = new String() ;
		if(me.Suchart.value == 'fulltext') { // FixMe: Das gilt nur wenn es nicht unterschiedliche Operatoren gibt, sonst mu� ich gruppieren ...
			param2 += "?text bds:search " + '"' + me.Stichwort.value + '" ;"';
			param2 += ' bds:matchAllTerms "true" .'  ; //FixMe: Hier einen Oder-Parameter als "false" �bernehmen 
		}
		else if(me.Suchart.value == 'regex') {
			/* regex-Ausdr�cke maskieren?
			\ => %5C ??? Wie wird das durch die Verarbeitungskette gereicht?
			' und " maskieren?
			*/
			param2 += "FILTER(" ;
			for(i = 0; i < Stichwoerter.length; i++){
				param2 +='regex(?text,"'+ Stichwoerter[i] +'","i")';
				if(i > 0) {
					params +=' && '; //FixMe: Das mu� ggf. den Operatoren angepa�t werden
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
	   	   // FILTER(?jahr <= .... && ?jahr >= ...) # Zeitliche Einschr�nkung
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
	   	   param2 +=' ?konto bk:account ' + me.konto.value + ' . ' //  # Einschr�nkung auf Konto (incl. Unterkonten)
	   	   // ??? Liste von Konten
	   }
	   if(me.betrag.value != '') {
	   	   param2 += 'FILTER(?betrag ' + me.betragsoperator.value + ' ' + me.betrag + ')'; // # W�hrungsumrechnungen mit ber�ckichtigen? 
	   	   // FixMe: Sicherstellen, da� betrag eine Zahl ist
	   	   //ToDo: betragsoperatoren wie "zwischen" und "ca" ( > x*0.95 && < )x*1.05 auswerten
	   }
		
		
		me.params.value="$1|" + me.Stichwort.value + ";$2|" + param2 ;
		alert(me.params.value) ; //Debug
		me.Stichwort.setAttribute("disabled", "disabled");
		return true;
	
}
/* Ein Objekt mit den ganzen Funktionen? */
function searchTerms(stichwort) {
	/* gibt einen Array der Stichw�rter und der Operatoren zur�ck */
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