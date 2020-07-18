#!/bin/bash -ex
echo "hello I'm runing from $PWD"
mkdir output || true
bats testing/tests.bats > output/results.txt
cd output/
pageres http://localhost 800x600
