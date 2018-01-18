view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [0,10,20,30,40,50,60,70,80,90]
    style: integer
    sql: ${age} ;;
    drill_fields: [age]
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    link: {
      url: "google.com"
      label: "google1"
    }

    link: {
      url: "google.com"
      label: "google19"
    }

    link: {
      url: "google.com"
      label: "google18"
    }

    link: {
      url: "google.com"
      label: "google17"
    }

    link: {
      url: "google.com"
      label: "google15"
    }

    link: {
      url: "google.com"
      label: "google16"
    }

    link: {
      url: "google.com"
      label: "google13"
    }

    link: {
      url: "google.com"
      label: "google11"
    }

    link: {
      url: "google.com"
      label: "google12"
    }

    link: {
      url: "google.com"
      label: "google14"
    }

    link: {
      url: "google.com"
      label: "google3"
    }

    link: {
      url: "google.com"
      label: "google2"
    }
    drill_fields: [state, city, zip, age, email, gender]
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type: string
    sql: concat(${first_name},' ',${last_name}) ;;
    label: "Name"
    description: "User's full name"
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
