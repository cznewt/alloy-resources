#!/usr/bin/env just --justfile

default:
  just --list

test-scenario +SCENARIO:
    @export SCENARIO="{{SCENARIO}}"
    @echo "Testing {{SCENARIO}} scenario..."
    @SCENARIO={{SCENARIO}} docker compose up

test-batocera-scenario:
    @just test-scenario batocera

test-docker-scenario:
    @just test-scenario docker

test-hassos-scenario:
    @just test-scenario hassos

test-relay-scenario:
    @just test-scenario relay

test-all:
    @echo "Testing all scenarios..."
    @just test-scenario batocera
    @just test-scenario docker
    @just test-scenario hassos
    @just test-scenario relay
