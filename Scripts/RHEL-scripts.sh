sudo -s
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install -y python-pip
	which pip
	rpm -qa|grep pip

pip install azure==2.0.0rc5


sudo su -
yum -y install ansible


wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/azure_rm.py
chmod +x azure_rm.py
