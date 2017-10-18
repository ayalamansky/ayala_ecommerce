view: user_data {
  derived_table: {
    sql:
      select users.id, count(*) total_num_orders,
      min(date(orders.created_at)) first_order_date, max(date(orders.created_at)) last_order_date from
      users
      left outer join orders on users.id = orders.user_id
      group by 1 ;;
    sql_trigger_value: SELECT CURDATE() ;;
    indexes: ["id"]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: total_num_orders {
    type: number
    sql: ${TABLE}.total_num_orders ;;
  }

  dimension: is_high_value {
    type: yesno
    sql: ${total_num_orders} >= 15 ;;
    label: "High-Value Customer"
    description: "User has more than 15 lifetime orders"
  }

  dimension: first_order_date {
    type: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: last_order_date {
    type: date
    sql: ${TABLE}.last_order_date ;;
  }

  measure: count {
    type: count
    drill_fields: [users.last_name, users.first_name, users.id, total_num_orders, first_order_date, last_order_date]
  }

}
