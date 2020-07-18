#!/usr/bin/env bats

@test "nginx installed" {
  apt list --installed | grep nginx
}

@test "talk to port 80" {
  curl localhost
}
