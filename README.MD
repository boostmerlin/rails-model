生成ActiveRecord模型
======

## Env
ruby: 2.5.7+
## Usage

1. install ruby

    * use rvm, rbenv or yum install ruby.
    * bundle config mirror.https://rubygems.org https://gems.ruby-china.com

2. `bin/setup`
    > 安装mysql2 可能遇到问题, 需要安装相应依赖, try: 

        gem install mysql2 -- --with-mysql-dir=/path/to/mysql

        try to install ruby-devel libmysql-ruby mysql-devel openssl-devel

        'sudo apt-get install libmariadb-dev', 'sudo apt-get install libmysqlclient-dev' or 'sudo yum install mysql-devel'  

    > ld: library not found for -lssl  

        export LDFLAGS="-L/usr/local/opt/openssl/lib"  
        export CPPFLAGS="-I/usr/local/opt/openssl/include"
        gem install mysql2 -v '0.5.3' -- --with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include

3. `bin/models` 生成模型

4. `[GM=1] rails c [env]`
