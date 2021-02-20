# product_ping
Ping products to check their in-stock status

## Dependencies
ProductPing depends on [Amazon SES](https://aws.amazon.com/ses/) to send emails.

## Configuration
Set these environment variables:
```
FROM_EMAIL="from@example.com"
TO_EMAIl="your.email@example.com"
AWS_ACCESS_KEY_ID=<id>
AWS_SECRET_ACCESS_KEY=<secret>
AWS_REGION=<region>
```

## Setup

Create some products to follow:
```
Product.create!(name: "Some cool product", url: "https://www.newegg.com/p/N82E16824012018?Description=monitor&cm_re=monitor-_-24-012-018-_-Product&quicklink=true")
```

Run this daemon to ping products every 30 seconds:
```
rails products:ping
```

Run this worked to process the delayed jobs:
```
QUEUE=products bundle exec rake jobs:work
```
