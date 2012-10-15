#!/bin/bash
apt-get -y install git python-ldap python-virtualenv ruby
gem install hub rake
su vagrant -c '
#curl -L https://get.rvm.io | bash -s stable --ruby;
#source /home/vagrant/.rvm/scripts/rvm;
#rvm install 1.9.3;
#rvm use 1.9.3;
#gem install hub;
hub clone samphippen/dotfiles ~/.dotfiles;
cd ~/.dotfiles;
echo "O" | rake install;
cd ~;
#build the finalstep.sh script
sudo cp /vagrant/finalstep.sh ./;
sudo cp /vagrant/createorg.ldif ./createorg.ldif ;
sudo cp /vagrant/createusers.ldif ./createusers.ldif ;
sudo cp /vagrant/creategroups.ldif ./creategroups.ldif ;
sudo su -c "chmod 666 ~vagrant/*.ldif"
sudo chmod 777 finalstep.sh
'
sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq slapd ldap-utils
echo "now you should login to the box with \`vagrant ssh\`"
echo "then you should run \`./finalstep.sh\` to setup the box for srobo ldap"
