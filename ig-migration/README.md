# DB Migrations

Migrations with `node-pg-migrate`

## Generate empty migration files

Example:

```sh
npm run migrate create rename contents to body
```

## Up Migration

```sh
DATABASE_URL=postgres://USERNAME:PASSWORD@localhost:5432/socialnetwork npm run migrate up
```

## DOWN Migration

```sh
DATABASE_URL=postgres://USERNAME:PASSWORD@localhost:5432/socialnetwork npm run migrate down
```
