view: orders {
  sql_table_name: demo_db.orders ;;

  filter: test_time {
    type: date
    convert_tz: no
  }

  dimension_group: test_time_2  {
    timeframes: [raw]
    type: time
  }

  dimension: test_output {
    sql: {% date_start test_time %} ;;
  }

  dimension: test_output_2 {
    sql: {% date_start test_time_2_raw %} ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_complete {
    type: yesno
    sql: ${status} ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }
}
