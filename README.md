Název systému
Popis účelu systému a jeho místa v kontextu stranických IT systémů
Pro hlasovani vseho druhu. Administraci hlasovani, rozesilani upozorneni, vyhodonocovani vysledku.
Zkratka odstraneni zasahu lidskeho administratora z procesu.

Popis způsobu zpřístupnění systému uživatelům
Vlastni aplikace se deli na 2 casti: serverovou (SP - Server Part) a klientskou (CP - Client Part).
Server komunikuje pres JSON RESTful api.
Pro lidi vsak hezke klikatko jako klientska webapp bezici v prohlizeci na subdomene.pirati.cz.

Popis způsobu integrace s ostatními stranickými systémy
Uzivatelska zakladna skrz graph api, autentizace skrz openID provider.

Provozní požadavky (HW, SW, lidské zdroje)
SP jako node.js aplikace muze bezet na cloud apphostingu (www.heroku.com) s primym napojenim na piratskou DB.
Rozlozi se tak zatez v systemu, piratsky server = jen DB.
V ramci kontroly kazda hlasovaci akce posila log (JSON zpravy?) na nejaky externi server (alternativa dozorci komise) mimo spravu hlasovaciho serveru.

CP taktez na cloud apphostingu.
Z duvodu rozdeleni na SP a CP (obe fakticky na jinych cloud app kontejnerech), a SP v node.js, predpokladam malou zatez.
Kdyby vzrostla nad unosnou mez, lze resit:
- zaplaceni dalsich cloud prostredku
- nejakou formu load balancingu mezi vice cloud app kontejnery
- presun na piratsky server

Koncepční specifikace systému
SP:
Node.js JSON RESTful server. Jazyk idealne coffeescript. Knihovny: express.js nebo http://mcavage.me/node-restify/?.
Nastaveni v extra configuracich (soucasti zdrojaku jsou jen examply - konkretni nastaveni pak jen na serveru) a nebo v env variables.
CP:
Node.js applikace v angular superhero frameworku.
Design by twitter-bootstrap ale customizovatelne templates v nejakem chytrem templatovacim jazyku (EJS, CoffeeCup).

Základní specifikace datového modelu

Entity:
- Hlasovani: <ID (bigint)>, nazev, popis, url, zacatek (datetime), konec (datetime), zpusob (enum)
- Option: <ID (smallint), hlasovaniID>, nazev, popis
- Hlas: <ID (bigint)>, hlasovani (FK), personID, chosenOptionID, issued (datetime), 

Základní specifikace funkcionality

Specifikace způsobu a organizace vývoje a testování
Vyvoj organizovani pres github nastroje. Unit testing a E2E testing v beznych JS nastrojich. Testy soucasti zdrojaku.

Specifikace způsobu a organizace ostrého provozu
Ostry provoz idelani na cloud app hostingu.
Release pouze po passed testech pomoci GITu (na heroku je to standard) pro snadny revert kdyz se to jooo pokazi.
