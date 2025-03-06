#!/usr/bin/env bash

# Recursively find all pubspec.yaml files and run flutter clean in their directories.
find . -name pubspec.yaml -execdir flutter clean \;
