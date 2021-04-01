#Anotace
Sucho je aktuálně čím dál více probírané téma a naše práce se jím zabývá. Cílem je vytvořit mobilní aplikaci pro inteligentní ovládání zavlažování v domácnosti. Hlavním přínosem by mělo být efektivní hospodaření s vodou, zalévání při podmínkách, kdy to dané rostliny požadují a žádné starosti.

#Annotation
Drought is currently an increasingly discussed topic and our work deals with it. The goal is to create a mobile application for intelligent control of irrigation. The main benefit should be efficient water management, watering under conditions where the plants require it and no worries.

#Klíčová slova
PHP, Laravel, chytré zavlažování, IoT, Flutter

#Key words
PHP, Laravel, Smart water system, IoT, Flutter

#Úvod:
Internet věcí (Internet of Things - IoT) označuje systém vzájemně propojených zařízení, která jsou připojena k internetu. Tento systém je schopný shromažďovat a přenášet data přes bezdrátovou sít bez lidského zásahu.
Naše hlavní myšlenka je udělat řídící jednotku uvnitř domu, která se bude starat o zavlažování venkovní části pozemku. Bude se programovat stejně jako arduino. Tato jednotka bude přijímat bezdrátově rozkazy z webové aplikace, která bude přijímat nastavení z mobilní aplikace a hodnoty čidel z řídící jednotky. Podle nastavení a hodnot z čidel se webová aplikace rozhodne, které sektory se zalijí a pošle rozkazy do řídící jednotky.
Jelikož žijeme v pokročilé době, tak chceme, abychom pracovali co nejefektivněji s vodou. Na pozemku máme skleník, okrasné květiny, trávník a samozřejmě nádrž s vodou. Já si v aplikaci nastavím priority daných zón (skleník bude mít nejvyšší prioritu, tedy 1). Čidla budou snímat hladinu vody a program vyhodnotí podle priorit, jak bude zalévat. Pokud bude nízká hladina vody, zalejí se pouze prioritní věci (v našem případě skleník). Pokud bude více vody, tak se zalejí priority nižších řádů. Vše se dá nastavit v aplikaci.
