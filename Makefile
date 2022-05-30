
query:
	sfdx pogilvie:query:soql -f ./scripts/soql/Account.soql -u mockdata 

query = "\
SELECT \
    Id, \
    Name, \
    Owner.Profile.Name, \
    (SELECT Id, Name, Owner.Profile.Name FROM Contacts) \
FROM Account \
ORDER BY Name \
LIMIT 10"

query-inline:
	sfdx force:data:soql:query \
		-q $(query) \
		-u mockdata

scratch:
	sfdx force:org:create \
		--setalias mockdata \
		--definitionfile ./config/devorg.json \
		--targetdevhubusername dev \
		--wait 20

list:
	sfdx force:org:list

push:
	sfdx force:source:push -u mockdata

pull:
	sfdx force:source:pull -u mockdata

open:
	sfdx force:org:open -u mockdata -b chrome

accounts:
	sfdx force:data:bulk:upsert \
		-s Account \
		-i RowId__c \
		-f ./data/Account.csv \
		- w 20
		-u mockdata

contacts:
	sfdx force:data:bulk:upsert \
		-s Contact \
		-i RowId__c \
		-f ./data/Contact.csv \
		-w 20 \
		-u mockdata

