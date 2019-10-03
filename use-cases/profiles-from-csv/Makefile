SHELL := /bin/bash
MAKEFILE_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

CONDA_ENV := project-charlie

#####################################################
# Need to be set ... defaulting to cice profiles ...
SCHEMA := cice/Customer
PROFILE_ID := fake-bob
IMPORT_FILES := import_files_cice
######################################################

SCHEMA_DIR := ${MAKEFILE_DIR}/schemas/${SCHEMA}
EVENTS_DIR := ${MAKEFILE_DIR}/events/${SCHEMA}

activate:
	@echo "conda activate --stack ${CONDA_ENV}"

setup_first_time:
	conda create -y -n ${CONDA_ENV} python=3.7 pip
	$$(dirname $$(dirname ${CONDA_PYTHON_EXE}))/envs/${CONDA_ENV}/bin/pip install -r ${MAKEFILE_DIR}/requirements.txt

dirs:
	mkdir -p ${SCHEMA_DIR}
	mkdir -p ${EVENTS_DIR}

import_files_cice:
	cp ${HOME}/Downloads/'CICE Profile Attributes - CustomerSchema.csv' ${SCHEMA_DIR}/schema.csv || true
	cp ${HOME}/Downloads/'CICE Profile Attributes - Taxonomy.csv' ${SCHEMA_DIR}/taxonomy.csv || true
	cp ${HOME}/Downloads/'CICE Profile Attributes - CustomerSamples.csv' ${EVENTS_DIR}/samples.csv || true

import_files_nbc_viewer:
	cp ${HOME}/Downloads/'NBC Profile Attributes - ViewerSchema.csv' ${SCHEMA_DIR}/schema.csv || true
	cp ${HOME}/Downloads/'NBC Profile Attributes - ViewerSamples.csv' ${EVENTS_DIR}/samples.csv || true
	cp ${HOME}/Downloads/'NBC Profile Attributes - Taxonomy.csv' ${SCHEMA_DIR}/taxonomy.csv || true

import_files_nbc_segment:
	cp ${HOME}/Downloads/'NBC Profile Attributes - SegmentSchema.csv' ${SCHEMA_DIR}/schema.csv || true
	cp ${HOME}/Downloads/'NBC Profile Attributes - SegmentSamples.csv' ${EVENTS_DIR}/samples.csv || true
	cp ${HOME}/Downloads/'NBC Profile Attributes - Taxonomy.csv' ${SCHEMA_DIR}/taxonomy.csv || true

deps: dirs ${IMPORT_FILES}
	@echo 'Schema must live here: ${SCHEMA_DIR}/schema.csv' && test -f '${SCHEMA_DIR}/schema.csv'
	@echo 'Sample Events must live here: ${SCHEMA_DIR}/samples.csv' && test -f '${SCHEMA_DIR}/schema.csv'

from_csv_schema_to_json_schema: deps
	csvjson '${SCHEMA_DIR}/schema.csv' \
		| jq --arg schema "${SCHEMA}" -f 'schema-from-excel-structure.jq' \
		> ${SCHEMA_DIR}/attributes.json
	csvjson '${SCHEMA_DIR}/taxonomy.csv' \
		| jq --arg schema "${SCHEMA}" -f 'taxonomy-from-excel-structure.jq' \
		> ${SCHEMA_DIR}/taxonomy.json
	jq -s '.[0] + .[1]' \
		<(cat ${SCHEMA_DIR}/attributes.json ) \
		<(cat ${SCHEMA_DIR}/taxonomy.json ) \
		> ${SCHEMA_DIR}/schema.json

from_csv_profiles_to_json_profiles: deps
	csvjson '${EVENTS_DIR}/samples.csv' \
		| jq -c 'include "cortex-schema-helpers"; .[] | cast_record_values_to_json ' \
		> ${EVENTS_DIR}/samples.json
	cat ${EVENTS_DIR}/samples.json \
		| cortex graph publish --dry-run --auto --transform transformer.js \
		| jq -c 'select(.event != "$$set" and .event != "profileId" and .event != "schemaId")' \
  	> ${EVENTS_DIR}/samples.ndjson

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

nbc-viewer:
	make -f ${MAKEFILE_DIR}/Makefile upload SCHEMA=nbc/Viewer IMPORT_FILES=import_files_nbc_viewer PROFILE_ID=viewer-1

nbc-segment:
	make -f ${MAKEFILE_DIR}/Makefile upload SCHEMA=nbc/ViewerSegment IMPORT_FILES=import_files_nbc_segment PROFILE_ID=segment-1

nbc: nbc-viewer nbc-segment

cice:
	make -f ${MAKEFILE_DIR}/Makefile upload SCHEMA=cice/Customer IMPORT_FILES=import_files_cice PROFILE_ID=fake-bob

downloads.clean:
	rm -i ${HOME}/Downloads/*'Profile Attributes'*

downloads.list:
	ls -1 ${HOME}/Downloads/*'Profile Attributes'*
