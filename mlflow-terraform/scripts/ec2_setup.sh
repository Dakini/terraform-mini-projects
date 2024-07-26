#! /bin/bash
sudo yum -y update
sudo yum install python3 -y
sudo yum install python3-pip -y
pip3 install jupyter 
pip3 install psycopg2-binary 
pip3 install scikit-learn
pip3 install mlflow 
# pip3 install boto3 
