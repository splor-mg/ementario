all: fonte data/fonte-recurso-temporal.csv

fonte: classificador/fonteRecurso/cod.json classificador/fonteRecurso/desc.json classificador/fonteRecurso/foreign_key.json

classificador/fonteRecurso/%.json: classificador/fonteRecurso/%.yaml
	cat $^ | yq -o=json > $@

data/fonte-recurso-temporal.csv: classificador/fonteRecurso/data.yaml
	Rscript scripts/transform.R