# Problem?

Problem? is a ultra-simple issue-tracking system. It is design to have the system up and running under 10 minutes.

It uses your coperate Active Directory to do authentication. Anybody who can login can basically report an issue, 
take ownership and close the issue. The target user base for this application is a small team of under 20 people
who would like to track their daily procedual jobs (loading data into server, tracking complaints, etc...)

## Ruby version
It has been tested to run on Ruby 2.0 and above and using Rails 4.2

## System dependencies
Requires Active Directory to handle user authentication

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
	SECRET_KEY_BASE=< results from "rake secret" command>
	default_admin=<SAM-account-name of your default admin>
```

create the database and seed the data for the workflow

```
	rake db:create
	rake db:migrate
	rake db:seed
```

## Deployment

After following the configuration steps, just run the application with the following command

`RAILS_ENV=production PORT=<port> foreman start`

Just access to your server. You should be able to login and start creating issue, and track them.


