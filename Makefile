DIRECTORIES = fonteRecurso unidadeOrcamentaria

JSON_TARGETS = cod.json desc.json foreign_key.json data.json

all: $(DIRECTORIES)

$(DIRECTORIES):
	$(foreach json,$(JSON_TARGETS),\
		cat classificador/$@/$(json:%.json=%.yaml) | yq -o=json > classificador/$@/dist/$(json);)

.PHONY: all $(DIRECTORIES)
