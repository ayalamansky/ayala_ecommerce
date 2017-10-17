view: inventory_items {
  sql_table_name: demo_db.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
    drill_fields: [id, products.item_name, products.id, cost]
  }

  measure: avg_cost {
    type: average
    sql: ${cost} ;;
    value_format_name: usd
    drill_fields: [id, products.item_name, products.id, cost]
  }

  measure: min_cost {
    type: min
    sql: ${cost} ;;
    value_format_name: usd
    drill_fields: [id, products.item_name, products.id, cost]
    label: "Minimum Cost"
    description: "Min cost for the grouping"
  }

  measure: max_cost {
    type: max
    sql: ${cost} ;;
    value_format_name: usd
    drill_fields: [id, products.item_name, products.id, cost]
    label: "Maximum Cost"
    description: "Max cost for the grouping"
  }
}
