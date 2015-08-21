#!/bin/bash

sudo mkdir -p /opt/spark
cd /opt/spark
sudo wget http://apache.go-parts.com/spark/spark-1.4.1/spark-1.4.1.tgz
sudo tar -czvf spark-1.4.1.tgz
sudo rm spark-1.4.1.tgz
