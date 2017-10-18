connection: "thelook"

# include all the views
include: "*.view"

datagroup: order_items_datagroup {
  max_cache_age: "4 hours"
  sql_trigger: select curdate() from order_items ;;
}

explore: order_items {
  persist_with: order_items_datagroup
  sql_always_where: ${orders.created_date} <= curdate();;
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_data {
    type: left_outer
    sql_on: ${users.id} = ${user_data.user_id};;
    relationship: one_to_one
  }
}

explore: orders {
  always_filter: {
    filters: {
      field: status
      value: "Complete"
    }
  }
}

explore: products {}

explore: users {
  join: user_data {
    type: left_outer
    sql_on: ${users.id} = ${user_data.user_id};;
    relationship: one_to_one
    fields: [total_num_orders, is_high_value]
  }
}

explore: users_high_value {
  from: users
  always_join: [user_data]
  join: user_data {
    type: inner
    sql_on: ${users_high_value.id} = ${user_data.user_id} and ${user_data.is_high_value};;
    relationship: one_to_one
    fields: [total_num_orders]
  }
}
