#!/bin/bash
set -e

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

function create_net () {
        echo "# Create net"
        if ! openstack network list | grep -q "\<${net_name}\>" ; then
                echo "Create Network $net_name" 
                openstack network create "${net_name}"
        fi

        net_id="$(openstack network list |  awk '($4 == "'${net_name}'"){print $2}')"
        echo "=>  net_id : $net_id"
}
      
    
function create_subnet () {
        echo "# Create subnet"
        if !  openstack subnet list | grep -q "\<${subnet_name}\>" ; then
                echo "Create subnet $subnet_name"
                openstack subnet create "${subnet_name}" --network ${net_name} --subnet-range "${subnet_range}" --gateway $"${subnet_gateway}" --allocation-pool "${subnet_alloc_pool}" --dns-nameserver "${subnet_dns_nameserver}"
        fi
    
        subnet_id="$(openstack subnet list | awk '($4 == "'${subnet_name}'"){print $2}')"
        echo "=>  subnet_id : $subnet_id" 
}   
    
    
function create_router () {
        echo "# Create router"
        if ! openstack router list | grep -q "\<${router_name}\>" ; then
                echo "Create router ${router_name}"
                openstack router create "${router_name}"
                openstack router set --external-gateway "${router_external_gateway}" "${router_name}"
                openstack router add subnet "${router_name}" "${subnet_name}"
        fi

        router_id="$(openstack router list | awk '($4 == "'${router_name}'"){print $2}')"
        echo "=>  router_id : $router_id"
}


function create_security_group () {
        echo "# Security Group"
        if ! openstack security group list | grep -q "\<${security_group_name}\>" ; then
                echo "Create security group ${security_group_name}"
                openstack security group create "${security_group_name}"
                openstack security group rule create --dst-port 22 --ingress "${security_group_name}"
                openstack security group rule create --protocol icmp "${security_group_name}"
        fi

        security_group_id="$(openstack security group list | awk '($4 == "'${security_group_name}'"){print $2}')"
        echo "=>  security_group_id : $security_group_id"
}

function create_keypair () {
        echo "# Key pair"
        if ! openstack keypair list | grep -q "\<${keypair_name}\>" ; then
                openstack keypair create --public-key "${keypair_public_key}" "${keypair_name}"
        fi
}


function run_instance () {
        echo "# Run Instance command"
        echo openstack server create --flavor "${instance_flavor}" --image "${instance_image}" --key-name "${keypair_name}" --network "${net_name}" --security-group "${security_group_name}" "${instance_name}" --min "${instance_count_number}" --max "${instance_count_number}"
}



### Main
create_net
create_subnet
create_router

create_security_group
create_keypair

run_instance
                                                                                                                                                                                            90,1          Bas

