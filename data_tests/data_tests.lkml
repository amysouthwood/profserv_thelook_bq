test: order_item_id_is_unique {
  explore_source: order_items {
    column: id {}
    column: count {}
    sorts: [order_items.count: desc]
    limit: 1
  }
  assert: order_item_id_is_unique {
    expression: ${order_items.count} = 1 ;;
  }
}
