[![Build Status](https://dev.azure.com/Blijven-leren/blijvenleren/_apis/build/status%2Ffbholai.blijvenleren?branchName=main)](https://dev.azure.com/Blijven-leren/blijvenleren/_build/latest?definitionId=3&branchName=main)
 
# Blijvenleren


## Achtergrondinformatie
BlijvenLeren is een nieuwe startup die zichzelf tot doel heeft gesteld om leren, kennisdelen en samenwerken binnen bedrijven nieuw leven in te blazen. Zij willen een platform bouwen waarop medewerkers van bedrijven leer resources kunnen opbouwen, verzamelen en met elkaar kunnen delen. Het unieke aan het platform is dat delen van de leer resources ook beschikbaar kunnen worden gesteld aan het publiek. Door mensen van buiten de organisatie toegang te geven tot de leeromgeving, kan een bedrijf een community bouwen, nieuw talent aanspreken, en gebruik maken van kennis buiten de organisatie. 

Deze nieuwe applicatie is 3 maanden geleden gepitched bij een aantal investeerders en er is toen een bedrag van EUR 50.000,- opgehaald om een eerste versie van deze applicatie te ontwikkelen en beschikbaar te maken. Na een succesvolle demo is er door de overheidscoöperatie Wigo4lt besloten naar productie te gaan met deze omgeving. Naast een team van ontwikkelaars die zich gaan bezighouden met de applicatie, zal jij worden toegevoegd aan het DevOps team om de benodigde infrastructuur op te zetten en deze productie ready te maken.

# Brainstorm
![brainstormv2](https://github.com/fbholai/blijvenleren/assets/116769493/f87bc44a-25ab-461f-bf67-414a56cb13e2)

# Compliancy

met behulp van azure policy is de staat van je infrastructuur in te zien. Door middel van beleid dwing je consistentie af voor je Cloud infrastructuur. Als voorbeeld is het mogelijk resources alleen aan te kunnen maken in een gedefiniëerde regio.

Defender for cloud integreert met AKS. Zo is het mogelijk om op de hoogte gebracht te worden van aanbevelingen die worden gegenereerd door Defender for cloud. met defender for containers krijg je adviezen over de juiste configuratie van je cluster.

Ook kan er gekeken worden naar code compliancy met name bicep linter configuratie. Hiermee zijn code best-practices af te stellen voor ontwikkelaars.

# Backup
backup van storage accounts en azure files is mogelijk vanuit azure backup. Voor AKS is de Kubernetes Service backup (preview) aanwezig. Hiermee is het mogelijk om de data te backuppen en te restoren. Voor backup dient een extension in de cluster geinstalleerd te worden. De extension heeft ook een blob storage-account nodig om de backup data hierin op te slaan.

