### Postgres database setup

Akwaba Express requires a postgres database engine, version 9.5 or later.

* Create role:
  ```bash
  sudo -u postgres createuser -P akwaba     # prompts for password
  ```
* Create databases:
  ```bash
      sudo -u postgres createdb -O akwaba akwaba_express
  ```