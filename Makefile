all: fonte

fonte: classificador/fonteRecurso/dist/cod.json classificador/fonteRecurso/dist/desc.json classificador/fonteRecurso/dist/foreign_key.json classificador/fonteRecurso/dist/data.json

classificador/fonteRecurso/dist/%.json: classificador/fonteRecurso/%.yaml
	cat $^ | yq -o=json > $@
