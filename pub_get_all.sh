#!/usr/bin/env bash
# Recursively run flutter pub get in every directory containing a pubspec.yaml

find . -name pubspec.yaml -execdir flutter pub get \;
