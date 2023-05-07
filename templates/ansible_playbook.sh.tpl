#!/bin/bash

rm -rf ${an_folder_path}
git clone ${an_git_link} ${an_folder_path}
cp -R ${an_folder_path}/inventory/sample ${an_folder_path}/inventory/my-cluster