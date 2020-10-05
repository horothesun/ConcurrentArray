# ConcurrentArray

![CI Linux](https://github.com/horothesun/ConcurrentArray/workflows/CI%20Linux/badge.svg)
![CI macOS](https://github.com/horothesun/ConcurrentArray/workflows/CI%20macOS/badge.svg)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/cocoapods/l/ImmutableGraph.svg?style=flat)](http://cocoapods.org/pods/ImmutableGraph)

Thread-safe Swift array.

## Generate Xcode project

```bash
swift package generate-xcodeproj
```

## Testing

### macOS

```bash
swift test
```

### Docker Linux

IMPORTANT: regenerate Linux test list executing

```bash
swift test --generate-linuxmain
```

Execute on base `swift:5.2` image

```bash
docker run --rm \
    --volume "$(pwd):/package" \
    --workdir "/package" \
    swift:5.2 \
    /bin/bash -c "swift test --build-path ./.build/linux"
```

or create a new image based on `Dockerfile` and run it

```bash
docker build --tag concurrent-array .
docker run --rm concurrent-array
```
