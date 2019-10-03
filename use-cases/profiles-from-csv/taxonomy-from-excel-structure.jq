include "cortex-schema-helpers";

def taxonomy_from_record: (
  (
    (. | tags_from_tag_columns)
    +
    {
      "context": "cortex/profile-attribute-taxonomy"
    }
  )

);

{
   # From ... https://github.com/stedolan/jq/issues/104
  "taxonomy": map(taxonomy_from_record) | del(.[][] | nulls)
}
