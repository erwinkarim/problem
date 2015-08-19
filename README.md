# Problem?

Problem? is a ultra-simple issue-tracking system. It is design to have the system up and running under 10 minutes.

It uses your coperate Active Directory to do authentication. Anybody who can login can basically report an issue,
take ownership and close the issue. The target user base for this application is a small team of under 20 people
who would like to track their daily procedual jobs (loading data into server, tracking complaints, etc...)

## Ruby version
It has been tested to run on Ruby 2.0 and above and using Rails 4.2

## System dependencies
Problem? requires the following:-

* Active Directory - to handle user authentication
* sendmail/postfix - required for email notification
* Nginx - required as Web server with SSL capabilities

## Configuration

First get the latest copy from github and bundle install

```
git clone http://github.com/erwinkarim/problem
bundle install
```

create an `.env` file at the application root and modify the values to your coperate network

```
devise_ldap_host=<your Active Directory Domain Controller>
devise_ldap_domains={"<domain name short form>" => "<fully qualified domain name; example.com>"}
devise_ldap_base=<ldap base; DC=EXAMPLE,DC=COM>
default_admin=<SAM-account-name of your default admin>
SECRET_KEY_BASE=< results from "rake secret" command>
network_host=0.0.0.0
network_port=5000
email_address=<email address that will appear on email notifications>
```

setup the database

```
RAILS_ENV=production rake db:setup
```

### Email Configuration

Problem? will use sendmail/postfix to send out email notifications. However, if it doesn't work, try to configreu your sendmail to the following:-

For postfix:-
```
mydomain = your company's domain (eg: example.com)
myorigin = $myhostname
relayhost = your coporate mail server (eg: exchange server hostname)
```

## Deployment
### Creating the SSL certificate

If you have your own certificate for the server you can put it in `/etc/nginx/ssl` directory. Otherwise, you can follow these instructions to create your own SSL certificate.

```
sudo mkdir /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
```

Answer all the questions. The most important thing is the Common Name. Key in your IP address or FQDN

### Nginx Configuration
Install Nginx on your machine.

Add the following in your /etc/nginx/nginx.conf file and be sure to take note on the upstream app and root configuration:-
```
upstream app {
	server unix:<your application dir>/tmp/unicorn.problem.sock fail_timeout=0;
}

server {
	listen 443;
	ssl on;
	ssl_certificate /etc/nginx/ssl/nginx.crt;
	ssl_certificate_key /etc/nginx/ssl/nginx.key;

	server_name <FQDN or IP address>;
	root <your application dir>/public;
	access_log /var/log/nginx/access.log main;
	error_log /var/log/nginx/access.log info;

	location ^~ /assets/ {
		gzip_static on;
		expires max;
		add_header Cache-Control public;
	}

	try_files $uri/index.html $uri @app;
	location @app {
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto https;
		proxy_set_header Host $http_host;
		proxy_redirect off;
		proxy_pass http://app;
	}

	error_page 500 502 503 504 /500.html;
	client_max_body_size 4G;
	keepalive_timeout 10;
}
```
Start the Nginx service
```
service nginx start
```

### Starting

After following the configuration steps, just run the application with the following command

`RAILS_ENV=production foreman start`

Just access to your server. You should be able to login and start creating issue, and track them.


## Troubleshooting
### Nginx Issues
Due to SELinux, you might have issues attempt to connect to the server using sockets. You can disable SELinux to resolve this problem
```
setenforce 0
```
