# Copyright 2019 Cognitive Scale, Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#    http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Valid chars in line 34 is important!
def simple_to_complex_value_type: (
  if . == null
  then (
    null
  )
  else
    if test("^dimensional")
    then (
        # First item can be a profile link ...
        capture("^dimensional.(?<first>([a-zA-Z-/]|[[]|[]])+),(?<second>[a-zA-Z-/]+).$") |
        {
          "outerType": "cortex/attribute-value-dimensional",
          "innerTypes": [
            (.first | simple_to_complex_value_type),
            (.second | simple_to_complex_value_type)
          ]
        }
    )
    else
      if test("^list")
      then (
        capture("^list.(?<first>([a-z_A-Z-/]|[[]|[]])+).$") |
        {
          "outerType": "cortex/attribute-value-list",
          "innerTypes": (
	    if ((.first|debug) == "null")
	    then [] 
	    else [ (.first | simple_to_complex_value_type) ]
	    end
	  )
        }
      )
      else
        if test("^profile-link")
        then (
          capture("^profile-link.(?<first>[a-zA-Z-/]+).$") |
          {
            "outerType": "cortex/profile-link",
            "innerTypes": (
	      if ((.first|debug) == "null")
              then []
              else [ (.first | simple_to_complex_value_type) ]
              end
            )
          }
        )
        else
          if test("/")
          then (
            {
              "outerType": .,
              "innerTypes": []
            }
          )
          else
              {
                "outerType": "cortex/attribute-value-\(.)",
                "innerTypes": []
              }
          end
        end
      end
    end
  end
);


def unique_tags_in_attributes: (
  [ .[] | .tags] | flatten | unique
);

def tag_from_tag_line: (
  {
    "name": .,
    "label": ( . | split("/") | .[1] ),
    "parent": ( . | split("/") | .[0] ),
    "description": .,
    "context": "cortex/profile-attribute-tag"
  }
);

def facets_from_tag_group: (
  {
    "tags": ( [ . | unique_by(.name) | .[] | .name ] ),
    "name": .[0].parent,
    "label": .[0].parent,
    "description": .[0].parent,
    "context": "cortex/profile-attribute-facet"
  }
);

# def taxonomy_from_groups: ();

def schema_from_attributes: (
  . as $attributes
    | [ $attributes | unique_tags_in_attributes | .[] | tag_from_tag_line ] as $attributeTags
    | [ $attributeTags | group_by(.parent) | .[] | facets_from_tag_group ] as $facets
    | {
      "attributes": $attributes,
      "attributeTags": [ $attributeTags | .[] | del(.parent) ],
      "facets": ( $facets )
    }
);

def map_type: (
  if . == null then null else "cortex/attributes-\(.)" end
);

def simple_value_type_for_attribute: (
  if .valueType == "dimensional"
  then (
    if .LinkToOtherProfiles
    then (
      "\(.valueType)[profile-link[\(.innerType1)],\(.innerType2)]"
    )
    else (
      "\(.valueType)[\(.innerType1),\(.innerType2)]"
    )
    end
  )
  else (
    if .valueType == "list"
    then (
      if .LinkToOtherProfiles
      then (
        "\(.valueType)[profile-link[\(.innerType1)]]"
      )
      else (
        "\(.valueType)[\(.innerType1)]"
      )
      end
    )
    else (
      "\(.valueType)"
    )
    end
  )
  end
);

def value_type_for_attribute_from_value_columns: (
  ( .valueType = ( . | simple_value_type_for_attribute) )
    | del(.LinkToOtherProfiles, .innerType1, .innerType2)
);

def tags_from_tag_columns: (
  # . is expected to be a record with tag1, tag2, ... keys ...
  . + {
    "tags": [
      to_entries
        | .[]
        | select( .key | test("^tag[0-9]+$") )
        | .value
        | select ( . != null )
    ]
  }
  # get rid of the tag list ... (tag1, tag2, ...)
  | with_entries(select(.key | test("^tag[0-9]+$") | not))
);

def remove_unneeded_attribute_columns: (
  del(.UpdateFrequency)
);

def rename_attribute_columns: (
  (.name = .attributeKey)
  | del(.attributeKey)
);

def prepare_attribute: (
  value_type_for_attribute_from_value_columns
  | tags_from_tag_columns
  | remove_unneeded_attribute_columns
  | rename_attribute_columns
);

def simple_to_detailed_attribute: (
    ( .valueType = ( .valueType | simple_to_complex_value_type ) )
  | ( .type = ( .type | map_type) )
);


def clean_exported_schema: (
  walk(if type == "object" then with_entries(select( .key | test("^_") | not)) else . end)
);

def cell_to_json: (
  . as $i |
    (
      (try ($i | fromjson)) // $i
    )
);

def cast_record_values_to_json: (
  (
    to_entries
    | [
      .[]
      | {
        "key": .key,
        "value": (.value | cell_to_json)
      }
    ]
  ) | from_entries
);
