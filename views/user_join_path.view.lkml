view: user_join_path {
  derived_table: {
    sql_trigger_value: select 1 ;;
    sql: select 'users' as path
          UNION ALL
         select "order_items" as path
    ;;
  }

  dimension: path {
    type: string
    sql: ${TABLE}.path ;;
  }
}

view: events_join_path {
  derived_table: {
    sql_trigger_value: select 1 ;;
    sql: select 'order_items' as path
    ;;
  }

  dimension: path {
    type: string
    sql: ${TABLE}.path ;;
  }
}
