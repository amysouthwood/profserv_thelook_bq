test: order_id_is_unique {
  explore_source: orders {
    column: id {}
    column: count {}
    sorts: [orders.count: desc]
    limit: 1
  }
  assert: order_id_is_unique {
    expression: ${orders.count} = 1 ;;
  }
}
