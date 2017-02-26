# web
Pledge Website



### Running hot_development
With heroku credentials, call:
```
DATABASE_URL=$(heroku config:get DATABASE_URL -a pledge-action) bundle exec rails s -e hot_development
```

For development add the following line to `/etc/hosts` (use sudo)
```
127.0.0.1       localhost.pledgeaction.org
```
