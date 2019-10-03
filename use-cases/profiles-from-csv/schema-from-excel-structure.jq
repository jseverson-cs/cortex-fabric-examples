include "cortex-schema-helpers";

[
  .[] | prepare_attribute | simple_to_detailed_attribute 
]
| schema_from_attributes
| (
  {
    "name": $schema,
    "title": $schema,
    "profileType": $schema,
    "description": $schema
  } + .
)
