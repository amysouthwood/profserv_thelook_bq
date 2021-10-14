
# adding a comment v14
# Define the database connection to be used for this model.
connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: amy_s_bq_sandbox_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: amy_s_bq_sandbox_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Amy S Bq Sandbox"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

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

explore: users {}

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
