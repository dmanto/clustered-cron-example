#!/bin/bash
addr=`getent hosts web_$1|awk '{print $1}'`
addr0=`getent hosts web_0|awk '{print $1}'`
addr1=`getent hosts web_1|awk '{print $1}'`
addr2=`getent hosts web_2|awk '{print $1}'`
etcd --name infra$1 --initial-advertise-peer-urls http://$addr:2380 \
     --listen-peer-urls http://$addr:2380 \
     --listen-client-urls http://$addr:2379,http://127.0.0.1:2379 \
     --advertise-client-urls http://$addr:2379 \
     --initial-cluster-token etcd-cluster-1 \
     --initial-cluster infra0=http://$addr0:2380,infra1=http://$addr1:2380,infra2=http://$addr2:2380 \
     --initial-cluster-state new &