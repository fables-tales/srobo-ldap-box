less << EOF2
when prompted to configure ldap:
    - set dns and organisation to sr
    - please set the password to '12345'

press q to continue

EOF2

rm -rf ~/userman
rm -rf ~/nemesis
sudo dpkg-reconfigure -plow slapd
sudo /etc/init.d/slapd stop
sudo su -c "sed -i s_dc=sr_o=sr_ /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{1\}hdb.ldif"
sudo /etc/init.d/slapd start

ldapadd -x -w 12345 -D "cn=admin,o=sr" -f createorg.ldif
ldapadd -x -w 12345 -D "cn=admin,o=sr" -f createusers.ldif
ldapadd -x -w 12345 -D "cn=admin,o=sr" -f creategroups.ldif

git clone git://srobo.org/userman.git
cd userman
git submodule init
git submodule update
sed s_Manager_admin_ -i sr/config.ini
echo "password=12345" >> sr/config.ini

./userman user add teacher_coll1 teacher teacher teacher@teacher.com
./userman user add teacher_coll2 teacher2 teacher teacher2@teacher.com

./userman user add student_coll1_1 student1 student student1@teacher.com
./userman user add student_coll1_2 student2 student student2@teacher.com

./userman user add student_coll2_1 student3 student student3@teacher.com
./userman user add student_coll2_2 student4 student student4@teacher.com

./userman college create "college the first"
./userman college create "secondary college"

./userman group create teachers
./userman group create students student

./userman group create team1
./userman group create team2
./userman group create team3

./userman group addusers teachers teacher_coll1
./userman group addusers teachers teacher_coll2

./userman group addusers students student_coll1_1
./userman group addusers students student_coll1_2
./userman group addusers students student_coll2_1
./userman group addusers students student_coll2_2

./userman group addusers college-1 teacher_coll1
./userman group addusers college-1 student_coll1_1 student_coll1_2

./userman group addusers college-2 teacher_coll2
./userman group addusers college-2 student_coll2_1 student_coll2_2

./userman group addusers team1 teacher_coll1 student_coll1_1
./userman group addusers team2 teacher_coll1 student_coll1_1


./userman group addusers team3 teacher_coll2 student_coll2_1 student_coll2_2

echo "type 'facebees'"
./userman user passwd teacher_coll1

echo "type 'noway'"
./userman user passwd teacher_coll2

echo "type 'cows'"
./userman user passwd student_coll1_1


cd ~

hub clone samphippen/nemesis
cd nemesis
git submodule init
git submodule update
cd nemesis/userman
git submodule init
git submodule update
sed s_Manager_admin_ -i sr/config.ini
sed "s_0\.1_0\.1:389_" -i sr/config.ini
echo "password=12345" >> sr/config.ini

cd ~/nemesis
virtualenv --distribute venv
source venv/bin/activate
pip install -r requirements.txt

cd test
sleep 1
./all_tests.sh

sudo apt-get -y install statsd python-dev libsqlite3-dev

echo "---------------------------------------------"
echo "now run these commands:"
echo "cd ~/nemesis"
echo "source venv/bin/activate"

echo ""
echo "that'll set you up for hacking on this!"
echo "---------------------------------------------"
