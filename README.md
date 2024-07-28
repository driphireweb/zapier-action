![Build And Deploy](https://github.com/driphireweb/zapier-action/workflows/Build%20and%20Deploy/badge.svg)
# GitHub Actions for Zapier

This Action for [zapier-platform-cli](https://platform.zapier.com/) enables arbitrary actions with the `zapier` command-line client.

## Inputs

- `args` - **Required**. This is the arguments you want to use for the `zapier-platform` CLI.

## Environment variables

- `ZAPIER_DEPLOY_KEY` - **Required if ZAPIER_DEPLOY_KEY is not set**. The token to use for authentication. This token can be acquired through the `zapier login` command.

- `key` - **Optional**. To specify a specific project to use for all commands. Not required if you specify a project in your `.zapierrc` file.

## Example

To authenticate with Zapier, and deploy to Zapier Hosting:

```yaml
name: Build and Deploy

on:
  pull_request:
    branches:
      - main

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '14'

      - name: Install Dependencies
        run: yarn

      - name: Build
        run: yarn zapier build
        env:
          NODE_ENV: production

      - name: Archive Production Artifact
        uses: actions/upload-artifact@v3
        with:
          name: build
          path: build

  deploy:
    name: Deploy
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v3

      - name: Download Artifact
        uses: actions/download-artifact@v3
        with:
          name: build
          path: build

      - name: Install Zapier Platform Core
        run: npm install zapier-platform-core

      - name: Deploy to Zapier
        uses: driphire/zapier-action@master
        with:
          args: upload
        env:
          ZAPIER_DEPLOY_KEY: ${{ secrets.ZAPIER_DEPLOY_KEY }}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

### Recommendation

If you decide to do separate jobs for build and deployment (which is probably advisable), then make sure to clone your repo as the zapier-platform-cli requires the zapier repo to deploy.