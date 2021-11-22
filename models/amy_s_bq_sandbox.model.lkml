
# adding a comment v16
# Define the database connection to be used for this model.
connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"
include: "/explores/*.explore.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: amy_s_bq_sandbox_default_datagroup {
  sql_trigger: select max(created_at) from `looker-private-demo.thelook.order_items` ;;
  max_cache_age: "1 hour"
}

persist_with: amy_s_bq_sandbox_default_datagroup


explore: distribution_centers {}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

# explore: order_items_2 {
#   view_name: order_items
#   always_join: [users]
#   join: users {
#     sql:
#     {% if order_items.filter_dynamic_dimension._parameter_value == "city" %}
#     LEFT JOIN users ON users.id = order_items.user_id
#     {% elsif order_items.filter_dynamic_dimension._parameter_value == "id" %}
#     {% else %}
#     LEFT JOIN users ON users.id = order_items.user_id
#     {% endif %};;
#     relationship: many_to_one
#     }
# }

# explore: order_items_3 {
#   view_name: order_items
#   always_join: [users,inventory_items]
#   join: users {
#     sql:
#     {% if order_items.filter_dynamic_dimension._parameter_value == 'city' %}
#     LEFT JOIN users ON order_items.user_id = users.id
#     {% elsif order_items.filter_dynamic_dimension._parameter_value == 'brand' %}
#     {% else %}
#     {% elsif order_items.filter_dynamic_dimension._parameter_value == 'id' %}
#     {% else %}
#     LEFT JOIN users ON order_items.user_id = users.id
#     {% endif %}
#     ;;
#     relationship: many_to_one
#   }
#   join: inventory_items {
#     sql:
#     {% if order_items.ilter_dynamic_dimension._parameter_value == 'brand' %}
#     LEFT JOIN inventory_items ON inventory_items.id = order_items.inventory_item_id
#     {% elsif order_items.filter_dynamic_dimension._parameter_value == 'city' %}
#     {% else %}
#     {% elsif order_items.filter_dynamic_dimension._parameter_value == 'id' %}
#     {% else %}
#     LEFT JOIN inventory_items ON inventory_items.id = order_items.inventory_item_id
#     {% endif  %}
#   ;;
#     relationship: many_to_one
#   }
#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id};;
#     relationship: many_to_one
#   }
# }

explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: users_2 {
  label: "Users - Cure for one to many blues"
  view_name:  users
  join: user_join_path {
    fields: []
    type: left_outer
    relationship: one_to_one
    sql_on: 0=1
      {% if order_items._in_query %} OR ${user_join_path.path} = 'order_items' {% endif %}
    ;;
  }
  join: order_items {
    type: left_outer
    relationship: one_to_one
    sql_on: ${user_join_path.path} = 'order_items' and ${users.id} = ${order_items.user_id} ;;
  }
}

explore: events_and_order_items {}


explore: events_2 {
  view_name: events
  join: order_items {
    sql_on: ${events.user_id} = ${order_items.user_id} ;;
    relationship: many_to_many
  }
}

explore: events_3 {
  view_name: events
  join: events_join_path {
    fields: []
    type: left_outer
    relationship: one_to_one
    sql_on: 0=1
      {% if order_items._in_query %} OR ${events_join_path.path} = 'order_items' {% endif %}
    ;;
  }
  join: order_items {
    type: left_outer
    relationship: one_to_one
    sql_on: ${events_join_path.path} = 'order_items' and ${events.user_id} = ${order_items.user_id} ;;
  }
}


# explore: user_order_items {
#   label: "Users - Outer Join on False"
# }


explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

# Place in `amy_s_bq_sandbox` model
explore: +events {
  aggregate_table: rollup__created_date {
    query: {
      dimensions: [created_date]
      measures: [users.user_count]
      filters: [events.created_date: "8 weeks"]
      timezone: "America/Los_Angeles"
    }

    materialization: {
      datagroup_trigger: amy_s_bq_sandbox_default_datagroup
    }
  }
}

# Place in `amy_s_bq_sandbox` model
explore: +events {
  aggregate_table: rollup__created_date__users_id {
    query: {
      dimensions: [created_date]
      measures: [users.user_count]
      filters: [
        events.created_date: "8 weeks",
        users.city: "Abbeville"
      ]
      timezone: "America/Los_Angeles"
    }

    materialization: {
      datagroup_trigger: amy_s_bq_sandbox_default_datagroup
    }
  }
}
