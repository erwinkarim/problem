# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
IssueStatus.create([
	{ name: 'Open', description: 'An issue has been created' },
	{ name: 'Acknowledged', description: 'The issue has been acknowledged by the support team' },
	{ name: 'Assigned', description: 'The issue has been assigned to somebody' },
	{ name: 'User Uncontactable', description: 'Attempted to call user but failed' },
	{ name: 'Escalate To Vendor', description: 'The issue has been escalted to a third party' },
	{ name: 'Resolved', description: 'The issue has been resolved but not acknowledged by the reporter' },
	{ name: 'Closed', description: 'The issue has been resolved and closed by the reporter' },
	{ name: 'Reopen', description: 'Reporter reopen the case' },
	{ name: 'Description Modified', description: 'Reporter modify the description of the issue' },
	{ name: 'Additional Comments', description: 'Comments added on the issue' },
	{ name: 'Re-assigned', description: 'Re-assign the issue to a new assignee' },
	{ name: 'In Progress', description: 'Adding comments for work in progress' }
])

Setting.create([
	{ category: 'site', key: 'brand', HelpText: 'Your Brand, recommended single word like Problem?' },
	{ category: 'site', key: 'title', HelpText: 'The text will appear at the top' },
	{ category: 'email', key: 'network_host', HelpText: 'The hostname to use when doing linking at email' },
	{ category: 'email', key: 'network_port', HelpText: 'The port to use when doing linking at email' },
	{ category: 'email', key: 'reply_address', HelpText: 'The reply address when Problem? sending out emails' }
])
