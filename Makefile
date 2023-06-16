all: fonte data/fonte-recurso-temporal.csv

fonte: classificador/fonteRecurso/cod.json classificador/fonteRecurso/desc.json

classificador/fonteRecurso/%.json: classificador/fonteRecurso/%.yaml
	cat $^ | yq -o=json > $@

data/fonte-recurso-temporal.csv: classificador/fonteRecurso/lookup.yaml
	Rscript scripts/transform.R