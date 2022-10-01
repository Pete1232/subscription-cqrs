# Github actions notes

[publishing docker](https://docs.github.com/en/packages/managing-github-packages-using-github-actions-workflows/publishing-and-installing-a-package-with-github-actions)

[metadata action](https://github.com/marketplace/actions/docker-metadata-action)

Note that the `labels` are not set properly on the container, since the image has already been built before those become available.
The only good way to deal with this would be to pass the labels into the Nix build.
