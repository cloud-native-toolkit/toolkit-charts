# Add Group OU
dn: ou=Groups{{with .Values.OpenLdap.Domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
objectclass: organizationalUnit
ou: Groups

# Add People OU
dn: ou=People{{with .Values.OpenLdap.Domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
objectclass: organizationalUnit
ou: People

# Add users
{{- $domain := .Values.OpenLdap.Domain }}
{{- $initialPassword := .Values.OpenLdap.SeedUsers.initialPassword }}
{{- with .Values.OpenLdap.SeedUsers.userlist | split ","}}
  {{- range . }}
dn: uid={{.}},ou=People{{with $domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
uid: {{.}}
displayname: {{.}}
sn: {{.}}
cn: {{.}}
userpassword: {{ printf $initialPassword }}
{{ end }}
{{- end }}

# Create ICP user group
dn: cn={{.Values.OpenLdap.SeedUsers.usergroup}},ou=Groups{{with .Values.OpenLdap.Domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
changetype: add
cn: {{.Values.OpenLdap.SeedUsers.usergroup}}
objectclass: groupOfUniqueNames
objectclass: top
owner: cn=admin{{with .Values.OpenLdap.Domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
{{- with .Values.OpenLdap.SeedUsers.userlist | split ","}}
  {{- range . }}
uniquemember: uid={{.}},ou=People{{with $domain | split "."}}{{range .}},dc={{.}}{{end}}{{end}}
  {{- end}}
{{- end}}
