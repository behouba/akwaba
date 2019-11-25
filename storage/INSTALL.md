### Postgres database setup

Akwaba Express requires a postgres database engine, version 9.5 or later.

* Create role:
  ```bash
  sudo -u postgres createuser -P akwaba     # prompts for password
  ```
* Create databases:
  ```bash
  for i in users deliveries employees ; do
      sudo -u postgres createdb -O akwaba akwaba_$i
  done
  ```