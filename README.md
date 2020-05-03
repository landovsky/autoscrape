# Moje Hypoška backend / admin front-end documentation
- [local development environment](#local_dev)
- [Github repositories](#github)
- [scheduled jobs](#scheduled_jobs)
- [ENV vars](#env)
- [Testing](#testing)

## <a name="local_dev"></a> Local development environment in Docker
Run environment locally with database and application server (tested on MacOS only).
- rename `.env.sample` to `.env`
- create volume for storing dependencies `docker volume create gem_store_263`
- `docker-compose up`

After the docker is finished, you should see
```
[273] * Listening on tcp://0.0.0.0:3000
[273] Use Ctrl-C to stop
```
and you can navigate to http://localhost:3000 (or the host port you've configured in .env).

## <a name="github"></a> Github repositiries
- development
  - merge feature branches to development
- staging
  - merge feature branches / development to staging when necessary
  - force push allowed
- master
  - merge development to master

## <a name="scheduled_jobs"></a> Scheduler
#### Rebuild search index
Rebuilds search index stored in `denormalized_products` table.

## <a name="env"></a> ENV vars
| Name                    | Mandatory | Note                                  |
| ----------------------- | --------- | ------------------------------------- |
| AUTH0_WEB_CONNECTION    | no        | Admin web Auth0 database.             |
| AUTH0_WEB_CLIENT_ID     | no        | Admin web Auth0Lock credentials.      |
| AUTH0_WEB_CLIENT_SECRET | no        | Admin web Auth0Lock credentials.      |
| AUTH0_WEB_DOMAIN        | no        | Admin web Auth0Lock domain.           |
| AUTH0_API_AUDIENCE      | no        | Unique identifier of custom API defined in Auth0 - tokens for client app are issued with this audience. |
| AUTH0_API_CLIENT_ID     | no        | Backend API Auth0 tenant credentials. |
| AUTH0_API_CLIENT_SECRET | no        | Backend API Auth0 tenant credentials. |
| AUTH0_API_TOKEN_URL     | no        | Endpoint for acquiring access token for Auth0 API client. |
| AUTH0_API_DOMAIN        | no        | SPA Auth0 tenant domain.              |
| AUTH0_PUBLIC_KEY        | no        | Auth0 tenant public key stored to improve performance. Can be found at https://AUTH0_DOMAIN.auth0.com/.well-known/jwks.json. |
| API_HOST_CESKA_SPORITELNA | yes     |                                       |
| API_KEY_CESKA_SPORITELNA  | yes     |                                       |
| DATABASE_URL            | yes       |                                       |
| HOST_URL                | no        | Needed to construct for example RPSN example urls. |
| SENDGRID_API_KEY        | no        |                                       |
| SENDGRID_BCC            | no        | Blind carbon copy to send all emails to |
| SENDGRID_FROM           | no        | From email address. Defaults to `Moje Hypoška <info@mojehyposka.cz>` |
| SENDGRID_TEMPLATE_ID_ORDER_BANK   | no | Sendgrid template ID for bank notification |
| SENDGRID_TEMPLATE_ID_ORDER_CLIENT | no | Sendgrid template ID for client notification |
| RAILS_ENV               | yes       | Beware, in `development`, authentication is bypassed. |
| RAILS_LOG_TO_STDOUT     | no        | log to STDOUT instead of file         |
| RAILS_LOG_LEVEL         | no        | defaults to `warn`                    |
| RAILS_MAX_THREADS       | no        | number of Puma threads within Puma worker <br/>defaults to `5` |
| SECRET_KEY_BASE         | yes       | verifies the integrity of signed cookies |
| SENTRY_DSN              | no        | Sentry auth url                       |
| SMS_NUMBER_WHITELIST    | no        | Comma separated numbers to which SMS will be sent in development / staging environments |
| TWILIO_ACCOUNT_SID      | no        | SMS integration                       |
| TWILIO_AUTH_TOKEN       | no        | SMS integration                       |
| TWILIO_SMS_NUMBER       | no        | SMS integration                       |
| VERIFICATION_CODE_RATE_SEC | no     | time in seconds before another SMS verification code can be requested,  <br/>defaults to `20`|
| VERIFICATION_EXPIRY_SEC | no        | time in seconds before SMS verification code expires,  <br/>defaults to `300`|
| WEB_CONCURRENCY         | no        | number of Puma workers (forked processes on single dyno) <br/>defaults to `1`|

## <a name="testing"></a> Testing
Application is tested with Rspec and Postman.

### Rspec
Traditional unit, model and feature tests.
`bundle exec rspec`

### Postman
GraphQL API query / mutation endpoints are tested by tests included in Postman collection.

**Setup notes**
- ensure `RAILS_ENV=test` variable, otherwise authentication tests might by falsely positive
- for local runs, setup database running `rake seeder:base` rake task (in CI, this is automated)
- after the tests are done, database is cleaned-up by calling admin GraphQL mutation

**Install and run**
- `sudo npm install -g newman`
- `newman run spec/graphql/moje-hyposka.postman_collection.json --global-var "host=localhost:3000"`


**Advantages**
- quick to write
- fast execution
- can run against local and remote environments

**Disadvantages**
- because of writes to database, tests must be composed carefully to prevent unique index violation and other types of errors that are otherwise prevented by running tests in transations or using database cleaner
- each update in Postman must be manually exported to spec/graphql/moje-hyposka.postman_collection.json
