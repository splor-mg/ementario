fonte: classificador/fonteRecurso/cod.json

classificador/fonteRecurso/%.json: classificador/fonteRecurso/%.yaml
	cat $^ | yq -o=json > $@
