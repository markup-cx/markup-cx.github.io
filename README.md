# Markup++ website

This repository contains the editable Nift source for the Markup++ website.
Generated pages live in the nested `public/` repository.

## Build locally

Install Nift or build the copy supplied beside this repository, then run:

```sh
nift build --all
nift status
bash tests/site_smoke.sh
```

When using the bundled source checkout from the development workspace:

```sh
../../nift/nift build --all
../../nift/nift status
bash tests/site_smoke.sh
```

Commit changes in `public/` before committing the outer source repository so
the source commit records the intended generated-site revision. See
`HANDOVER.md` for the full project conventions.

The root `install`, `download`, `update` and `uninstall` files are public shell
endpoints. Synchronize them byte-for-byte from the Markup++ repository's
canonical `packaging/` scripts and commit their generated `public/` copies.
