#!/bin/bash -e

depmod $(basename /lib/modules/*-v7+)
