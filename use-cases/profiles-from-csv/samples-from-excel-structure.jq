. as $root | 
  (
    $root | to_entries | .[] | select(.key != "profileId" and .key != "schemaId") | {
      event: .key,
      entityId: ($root.profileId | tostring),
      entityType: $root.schemaId,
      properties: .value
    }
  )
