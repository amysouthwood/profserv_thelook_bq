
view: events_and_order_items {
  derived_table: {
    sql: with
    --define CTE to pre-aggregated fact table #1
        order_items_source as (
        select
        --dynamically insert other fields based on what is selected.
        {%if created_date._in_query%}date(order_items.created_at) as created_date,{%endif%}
        {%if user_id._in_query%}order_items.user_id,{%endif%}
        {%if country._in_query%}users.country,{%endif%}
        --more fields need to be called out explicitly...
        sum(sale_price) as sale_price,
        count(*) as order_items_count
        from order_items
        left join users on order_items.user_id = users.id
        where 1=1
        and {%condition created_date%}order_items.created_date{%endcondition%}
        and {%condition country%}users.country{%endcondition%}
        group by 1
        --dynamically group by fields based on what is selected.
        {%if created_date._in_query%},date(order_items.created_at){%endif%}
        {%if user_id._in_query%},user_id{%endif%}
        {%if country._in_query%},country{%endif%}
        )
        ,

      --define CTE to pre-aggregated fact table #2
        events_source as (
        select
        --dynamically insert other fields based on what is selected.
        {%if created_date._in_query%}date(created_at) as created_date,{%endif%}
        {%if user_id._in_query%}user_id,{%endif%}
        {%if country._in_query%}country,{%endif%}
        --more fields need to be called out explicitly...
        count(*) as events_count
        from events
        where 1=1
        and {%condition created_date%}created_date{%endcondition%}
        and {%condition country%}country{%endcondition%}
        group by 1
        --dynamically group by fields based on what is selected.
        {%if created_date._in_query%},date(created_at){%endif%}
        {%if user_id._in_query%},user_id{%endif%}
        {%if country._in_query%},country{%endif%}
        )

      --Join pre-aggregated fact table #1 and fact table #2
        select
        --dynamically insert other fields based on what is selected.
        {%if created_date._in_query%}coalesce(order_items.created_date, events.created_date) as created_date,{%endif%}
        {%if user_id._in_query%}coalesce(order_items.user_id,events.user_id) as user_id,{%endif%}
        {%if country._in_query%}coalesce(order_items.country,events.country) as country,{%endif%}

        sum(sale_price) as sale_price,
        sum(order_items_count) as order_items_count,
        sum(events_count) as events_count
        from order_items_source as order_items left join events_source as events
        on 1=1
        --dynamically join on fields based on what is selected.
        {%if created_date._in_query%}and order_items.created_date=events.created_date{%endif%}
        {%if user_id._in_query%}and order_items.user_id=events.user_id{%endif%}
        {%if country._in_query%}and order_items.country=events.country{%endif%}

        group by 1
        --dynamically group by fields based on what is selected.
        {%if created_date._in_query%},coalesce(order_items.created_date, events.created_date){%endif%}
        {%if user_id._in_query%},coalesce(order_items.user_id,events.user_id){%endif%}
        {%if country._in_query%},coalesce(order_items.country,events.country){%endif%}
         ;;
  }

  measure: count {type: count label:"Row count for validation"}

  dimension: created_date {
    type: string
    sql: ${TABLE}.created_date;;
  }

  dimension: user_id {}
  dimension: country {}

  dimension: order_items_count {
    hidden: yes
    type: number
    sql: ${TABLE}.order_items_count ;;
  }

  dimension: events_count {
    hidden: yes
    type: number
    sql: ${TABLE}.events_count ;;
  }

  dimension: sale_price {
    hidden: yes
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_order_items_count {
    type: sum
    sql: ${order_items_count} ;;
  }

  measure: total_events_count {
    type: sum
    sql: ${events_count} ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }
}
