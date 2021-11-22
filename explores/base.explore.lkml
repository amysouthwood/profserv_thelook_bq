include: "/views/products.view.lkml"

explore: base {
  view_name: products
  extension: required
  access_filter: {field:products.brand
                  user_attribute: brand
    }
}
