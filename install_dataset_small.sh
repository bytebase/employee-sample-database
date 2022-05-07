#!/bin/bash

main() {
    path=$1
    user=$2

    cd $path/dataset_small
    mysql -u $user <employee.sql
}

main "" "root"
