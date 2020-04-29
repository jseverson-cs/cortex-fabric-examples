SHELL := /bin/bash
MAKEFILE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

SCHEMA_DIR := ${MAKEFILE_DIR}/schemas/${SCHEMA}
EVENTS_DIR := ${MAKEFILE_DIR}/events/${SCHEMA}
PROFILE_TYPE := ${SCHEMA}

activate:
	@echo "conda activate --stack ${CONDA_ENV}"

setup_first_time:
	conda create -y -n ${CONDA_ENV} python=3.7 pip
	$$(dirname $$(dirname ${CONDA_PYTHON_EXE}))/envs/${CONDA_ENV}/bin/pip install -r ${MAKEFILE_DIR}/requirements.txt

dirs:
	mkdir -p ${SCHEMA_DIR}
	mkdir -p ${EVENTS_DIR}

schema_deps: dirs ${IMPORT_FILES}
	@echo 'Schema must live here: ${SCHEMA_DIR}/schema.csv' && test -f '${SCHEMA_DIR}/schema.csv'

event_deps: dirs ${IMPORT_FILES}
	@echo 'Sample Events must live here: ${EVENTS_DIR}/samples.csv' && test -f '${EVENTS_DIR}/samples.csv'

from_csv_schema_to_json_schema: schema_deps
	csvjson '${SCHEMA_DIR}/schema.csv' \
		| jq --arg schema "${SCHEMA}" --arg profileType "${PROFILE_TYPE}"  -f 'schema-from-excel-structure.jq' \
		> ${SCHEMA_DIR}/attributes.json
	(test -f '${SCHEMA_DIR}/taxonomy.csv' && csvjson '${SCHEMA_DIR}/taxonomy.csv' \
		| jq --arg schema "${SCHEMA}" -f 'taxonomy-from-excel-structure.jq' \
		> ${SCHEMA_DIR}/taxonomy.json) || (cp ${MAKEFILE_DIR}/default-taxonomy.json ${SCHEMA_DIR}/taxonomy.json)
	jq -s '.[0] + .[1]' \
		<(cat ${SCHEMA_DIR}/attributes.json ) \
		<(cat ${SCHEMA_DIR}/taxonomy.json ) \
		> ${SCHEMA_DIR}/schema.json

from_csv_profiles_to_json_profiles: event_deps
	csvjson '${EVENTS_DIR}/samples.csv' \
		| jq -c 'include "cortex-schema-helpers"; .[] | cast_record_values_to_json ' \
		> ${EVENTS_DIR}/samples.json
	cat ${EVENTS_DIR}/samples.json \
                | jq -c -f 'samples-from-excel-structure.jq' \
        > ${EVENTS_DIR}/samples.ndjson
	# cat ${EVENTS_DIR}/samples.json \
	# 	| cortex graph publish --dry-run --auto --transform transformer.js \
	# 	| jq -c 'select(.event != "$$set" and .event != "profileId" and .event != "schemaId")' \
  	# > ${EVENTS_DIR}/samples.ndjson

upload_schemas: from_csv_schema_to_json_schema
	cortex profiles save-schema ${SCHEMA_DIR}/schema.json

upload_profiles: from_csv_profiles_to_json_profiles
	cat ${EVENTS_DIR}/samples.ndjson | cortex graph publish

upload: upload_schemas upload_profiles

export_schemas:
	cortex profiles describe-schema ${SCHEMA} \
	  | jq 'include "cortex-schema-helpers"; clean_exported_schema' > ${SCHEMA_DIR}/exported.json

missing_attributes:
	diff \
	  <(cortex profiles describe ${PROFILE_ID} ${SCHEMA} | jq -r '.profiles[0].attributes | map(.attributeKey) | unique | .[]') \
	  <(jq -r '.attributes | map(.name) | unique | .[] ' '${SCHEMA_DIR}/schema.json')

downloads.clean:
	rm -i ${HOME}/Downloads/*'Profile Attributes'*

downloads.list:
	ls -1 ${HOME}/Downloads/*'Profile Attributes'*
