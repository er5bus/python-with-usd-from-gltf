### USD, google usd_from_gltf with Python

This docker image containes a command-line tool, and import plugin for converting glTF models to [USD] (https://graphics.pixar.com/usd/docs/index.html) formatted assets for display in AR Quick Look.

Please note that this is not an officially supported Google product.

**Usage** : pull, run, then convert with: usd_from_gltf <source.gltf> <destination.usdz>


## Supported tags and respective `Dockerfile` links

* [`python3.8`, `python3.9` _(Dockerfile)_]()

**Docker** image with **USD**, **Google usd_from_gltf** and **Python** for web applications in **Python 3.8** and above, in a single container.

## Description

This [**Docker**](https://www.docker.com/) image allows you to create [**Python**](https://www.python.org/) web applications that run with [USD](https://github.com/PixarAnimationStudios/USD) in a single container.

Universal Scene Description (USD) is an efficient, scalable system for authoring, reading, and streaming time-sampled scene description for interchange between graphics applications.

For more details, please visit the web site [here](https://graphics.pixar.com/usd/release/index.html).

## How to use

* You shouldn't have to clone the GitHub repo. You should use it as a base image for other images, using this in your `Dockerfile`:

```Dockerfile
FROM er5bus/python-usd:python3.9-slim

# Your Dockerfile code...

```

## Tests

All the image tags, configurations, environment variables are tested.
