===============
openstack_tests
===============


tools to check/debug/test openstack



openstack_populate
==================

description
-----------


Create everything to pop instances (network, subnet, router, keypair, security group ...)


configure
---------

Conigure names in file header
 
  .. code:: bash

    net_name="test-net"
    
    subnet_name="test-subnet"
    subnet_range="10.1.0.0/24"
    subnet_gateway="10.1.0.1"
    subnet_alloc_pool="start=10.1.0.100,end=10.1.0.200"
    subnet_dns_nameserver="9.9.9.9"
    
    router_name="test-router"
    router_external_gateway="public"
    
    security_group_name="security_group_test"
    
    keypair_name="keypair-test"
    keypair_public_key="~/.ssh/id_rsa.pub"
    
    instance_name="instance-test"
    instance_flavor="m1.medium"
    instance_image="CentOS-7"
    instance_count_number="2"



run
---

 .. code:: bash

   $ ./openstack_populate.sh


