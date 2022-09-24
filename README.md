# subscription-cqrs

## development environment

Start a nix shell with

```sh
nix develop -i
```

## build and run locally

To run the full build

```sh
nix develop -i
> genericBuild
```

or as it runs in CI (make sure to delete all /target directories if running locally, and can still be flaky)

```sh
nix build --json
#  [{"drvPath":"/nix/store/34b4iqha5sjaj5dbbk3jw6k024dw02y5-docker-image-subscription-cqrs.tar.gz.drv","outputs":{"out":"/nix/store/dhmjfmlfp2pjsp2i0jkssa4kn2xqn6pm-docker-image-subscription-cqrs.tar.gz"}}]

OUT=$(nix build --json | jq -r ".[] | .outputs.out")

docker load -i $OUT
# Loaded image: subscription-cqrs:latest

docker run subscription-cqrs:latest
```
