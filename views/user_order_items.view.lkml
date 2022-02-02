view: user_order_items {
  derived_table: {
    datagroup_trigger: amy_s_bq_sandbox_default_datagroup
    sql: SELECT
              --  associated_users.age,
              --  associated_users.city,
                associated_users.state,
              --  associated_users.country,
              --  associated_users.gender,
              --  order_items.status,
              --  DATE_TRUNC(coalesce(associated_users.created_at,order_items.created_at),day) as date,
                count(associated_users.id) as count_users,
                avg(associated_users.age) as avg_age,
                count(order_items.order_id) as count_orders,
                sum(order_items.sale_price) as sale_price
         From users
         FULL OUTER JOIN order_items on FALSE
         LEFT JOIN users as associated_users
         ON associated_users.id = COALESCE (users.id,order_items.user_id)
         Group by 1
 ;;
  }

  measure: count {
    type: count
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: date{
    type: time
    sql: ${TABLE}.date ;;
  }

  measure: count_users {
    type: sum
    sql: ${TABLE}.count_users;;
  }

  measure: average_age {
    type: average
    sql: ${TABLE}.avg_age ;;
    value_format_name: decimal_1
  }

  measure: count_orders {
    type: sum
    sql: ${TABLE}.count_orders;;
  }

  measure: total_sale_price{
    type: sum
    sql: ${TABLE}.sale_price ;;
    value_format_name: decimal_2
  }
}
