# VismaSign

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/visma_sign`. To experiment with that code, run `bin/console` for an interactive prompt.

This gem is used for accessing visma sign api.

####### NOTE

Development in progress for updating

# API documentation
https://sign.visma.net/api/docs/v1/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'visma_sign'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install visma_sign

## Usage

##### Below are the required ENV for API to work
```ruby
  VISMAUSERNAME=<test@test.com>
  VISMAPASSWORD=<login password>
  GRANTTYPE=password
  VISMACLIENTID=<visma-client-uuid>
  VISMASCOPE=authorize_client billing_events_get category_create
```

##### Optional ENV
```ruby
  AS_ORGANIZATION=<organization uuid>
  TEST_EMAIL=<overide the email for sending invitation>
```
##### Usage

```ruby
  visma_api = VismaSign::Api.new
  #<VismaSign::Api:0x00007fb1908e56e0 @base_url="https://vismasign.frakt.io", @token="43e038748ce480b95d339dbcf30b6b5e591e3ea3">
```

```ruby
  visma_api.create_document({ document: { name: 'doc_name' } })
```

```ruby
  visma_api.search_document(payload: { name: 'doc_name' }
```

```ruby
  visma_api.add_file(<document_uuid>, <pdf file content>)
```

```ruby
  visma_api.create_invitation(
    uuid: <document_uuid>,
    email: <email>,
    full_name: <name>,
    number: <phone number>
  )
```

##### Available GRANTTYPE

  password

##### Available VISMASCOPE

  authorize_client billing_events_get category_create category_delete category_get_all category_update chat_link document_add_file document_batch_create document_batch_get_report document_batch_remind document_cancel document_check_latest document_create document_create_invitations document_delete document_get document_get_file document_get_received_invitations document_get_stats document_remind document_search document_separate_create document_update get_credits integration_create integration_get_all integration_update invitation_remind invitation_template_create invitation_template_delete invitation_template_get_all invitation_template_update invitation_update invitee_group_create invitee_group_delete invitee_group_entry_create invitee_group_entry_delete invitee_group_entry_update invitee_group_get_all invitee_group_update jwt_access_token organization_affiliate_children organization_api_credentials_get_all organization_create organization_external_get organization_get organization_get_users organization_image_set organization_image_delete organization_invitation_get_all organization_invitation_delete organization_invitation_remind organization_update organization_user_create organization_user_delete organization_user_update partner_authorize partner_get_all partner_reject person_current person_delete person_documents_delete purchase_get_options purchase_start received_invitations_get role_create role_delete role_get_all role_permission_add role_permission_remove role_update saved_invitation_message_create saved_invitation_message_delete saved_invitation_message_get_all saved_invitation_message_update organization_invitation_settings_modify subscription_get subscription_set_after_trial subscription_update feedback api_client_access

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/visma_sign. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/visma_sign/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VismaSign project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/visma_sign/blob/master/CODE_OF_CONDUCT.md).
