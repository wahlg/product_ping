# product_ping
Ping products to check their in-stock status

## Setup

Create some products to follow:
```
Product.create!(name: "Some cool product", url: "https://www.newegg.com/p/N82E16824012018?Description=monitor&cm_re=monitor-_-24-012-018-_-Product&quicklink=true")
```

Periodically run this task:
```
rails products:ping
```
