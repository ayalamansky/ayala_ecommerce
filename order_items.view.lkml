view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: sales_price_tier {
    type: string
    case: {
      when: {
        sql: ${sale_price} < 50 ;;
        label: "Discount"
      }
      when: {
        sql: ${sale_price} >= 50 and ${sale_price} < 300 ;;
        label: "Regular"
      }
      when: {
        sql: ${sale_price} >= 300 ;;
        label: "Luxury"
      }
      else: "Unknown"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
    value_format: "[{{ _user_attributes['brand'] }} == 'Canada Goose']0.00,,\"M\";[>=1000]0.00,\"K\";0"
  }

  measure: total_sale_mod_price {
    type: sum
    sql: ${sale_price} ;;
#     value_format_name: usd
    value_format: "[{{ _user_attributes['brand'] }} = 'Canada Goose']0.00,,\"M\";[>=1000]0.00,\"K\";0"
    drill_fields: [id, inventory_items.id, orders.id, sale_price]
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
#     value_format: "[{{ _user_attributes['brand'] }} = 'Canada Goose']0.00,,\"M\";[>=1000]0.00,\"K\";0"
    drill_fields: [id, inventory_items.id, orders.id, sale_price]
  }


  measure: total_sale_price_youth {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: {
    field: users.age_tier
    value: "10 to 19"
    }
    drill_fields: [id, inventory_items.id, orders.id, sale_price]
    label: "Total Sale Price for Youth"
    description: "Total sale price for people aged 10 to 19"
  }

  measure: percent_sales_youth {
    type: number
    sql: 1.0*${total_sale_price_youth}/nullif(${total_sale_price},0) ;;
    value_format_name: percent_2
    drill_fields: [id, inventory_items.id, orders.id, users.full_name, users.age_tier, sale_price]
    label: "Youth's Percent of Total Sales"
    description: "Percent of sales attributed to 10-19 year olds"
  }

  measure: total_margin {
    type: number
    sql: ${total_sale_price} - ${inventory_items.total_cost} ;;
    value_format_name: usd
    drill_fields: [id, inventory_items.id, orders.id, sale_price, inventory_items.cost]
  }

  parameter: cost_reduction {
    type: unquoted
    allowed_value: {
      label: "5%"
      value: ".05"
    }
    allowed_value: {
      label: "10%"
      value: ".1"
    }
    allowed_value: {
      label: "15%"
      value: ".15"
    }
  }

  dimension: profit {
    type: number
    sql: {% if cost_reduction._parameter_value == blank %}
        ${sale_price} - ${inventory_items.cost}
        {% else %}
        ${sale_price} - (${inventory_items.cost} *( 1 - {% parameter cost_reduction %}))
        {% endif %};;
  }

  measure: total_profit  {
    type: sum
    value_format_name: usd_0
    sql: ${profit} ;;
  }

  dimension: cost_reduction_value{
    type: string
    sql: {{ cost_reduction._parameter_value }} ;;
  }

  ## when summing retail_price of products in more granular order_items, need sum_distinct
  measure: total_price_distinct {
    type: sum_distinct
    sql_distinct_key: ${products.id} ;;
  sql: ${products.retail_price} ;;
  value_format_name: usd
  drill_fields: [id, orders.id, products.id, products.retail_price]
  }

  ## below is incorrect
  measure: total_price_not_distinct {
    type: sum
    sql: ${products.retail_price} ;;
    value_format_name: usd
    drill_fields: [id, orders.id, products.id, products.retail_price]
  }

}
