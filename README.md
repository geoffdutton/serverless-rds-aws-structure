# Serverless RDS with Lambda

This is the project repo for the blog post found here: [insert link when pubished]

## Perquisites

- AWS name profile set up: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
- Terraform v0.13.x installed globally (I used [tfenv](https://github.com/tfutils/tfenv))
- Serverless v2.x globally installed: `npm i -g serverless`

## Deploying

First, deploy the infrastructure, which will write files need by `serverless.yml`. In the `terraform` directory run:

```bash
$ terraform init
$ terraform apply -var="stage=dev"
```

Then in the root of the project, deploy serverless by running:

```bash
$ npm run deploy
```

Finally, test it by running:

```bash
$ npm test
```

## Destroying

Order is important because if you destroy the `terraform` infrastructure before `serverless`, it'll get stuck since the Security Groups and Subnet IDs are used by serverless. To make sure it's run in the correct order, in the root directory of the project, run:

```bash
$ npm run destroy
```
