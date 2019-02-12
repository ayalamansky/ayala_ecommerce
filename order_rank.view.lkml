include: "orders.view.lkml"
# explore: orders_test {
#   from: orders
#   view_name: orders
#   join: orders_with_ranking {
#     sql_on: ${orders.id} = ${orders_with_ranking.order_id} ;;
#   }
# }

explore: orders_with_ranking {}
view: orders_with_ranking {
  derived_table: {
    sql: select
     orders.id as order_id,
     {% if rank_by_age._parameter_value %}
     users.age,
     {% endif %}
     {% if rank_by_country._parameter_value %}
     users.country,
    {% endif %}
    {% if rank_by_age._parameter_value and rank_by_country._parameter_value %}
    ,rank() over (partition by country,age order by sale_price desc)
       {% elsif rank_by_age._parameter_value %}
      ,rank() over (partition by age order sale_price desc)
      {% elsif rank_by_country._parameter_value %}
      ,rank() over (partition by country order by sale_price desc)
      {% endif %} as rank
      FROM order_items
      LEFT JOIN orders ON order_items.order_id = orders.id
      left join users ON orders.user_id = users.id
      {% condition orders.created_date %} orders.created_at {% endcondition %}
      group by 1
      {% if rank_by_age._parameter_value and rank_by_country._parameter_value %}
      ,2,3
      {% elsif rank_by_age._parameter_value or rank_by_country._parameter_value %}
      ,2
      {% endif %}
      ;;
  }
  parameter: rank_by_user_age {
    type: yesno
  }
  parameter: rank_by_user_country {
    type: yesno
  }
  dimension: rank {}
  dimension: order_id {}
}

# view: order_with_ranking {
#   derived_table: {
#     sql:SELECT
#     {% if rank_by_age._parameter_value %}
#     users.age,
#     {% endif %}
#     {% if rank_by_country._parameter_value %}
#     users.country,
#     {% endif %}
#             COUNT(distinct orders.id) as num_orders,
#             ROW_NUMBER() over (order by count(distinct orders.id) desc) as rank
#       FROM orders
#       LEFT JOIN users ON orders.user_id = users.id
#       {% if rank_by_age._parameter_value and rank_by_country._parameter_value %}
#       GROUP BY 1,2
#       {% elif rank_by_age._parameter_value or rank_by_country._parameter_value %}
#       GROUP BY 1
#       {% endif %};;
#   }
#   parameter: rank_by_user_age {
#     type: yesno
#   }
#   parameter: rank_by_user_country {
#     type: yesno
#   }
#   dimension: rank {
#     type: number
#     sql: ${TABLE}.rank ;;
#   }
# }

# dimension: user_sales_rank {
#   sql: ROW_NUMBER() over (group by order by count(distinct orders.id) desc) as rank ;;
#   required_fields: [user.id]
##can you use this with cancel grouping fields?
# }
