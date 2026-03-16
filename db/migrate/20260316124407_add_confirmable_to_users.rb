class AddConfirmableToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    add_index :users, :confirmation_token, unique: true

    # Auto-confirm the existing account so Isara is not locked out after the migration.
    # :confirmable blocks sign-in until confirmed_at is set — without this,
    # the account would be immediately unusable.
    reversible do |dir|
      dir.up { User.reset_column_information && User.update_all(confirmed_at: Time.current) }
    end
  end
end
