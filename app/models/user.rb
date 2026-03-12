class User < ApplicationRecord
extend FriendlyId
friendly_id :email, use: :slugged # Use email as slug (unique)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :cv
  has_one_attached :avatar

  validate :single_user_only, on: :create

  # `dependent: :destroy` means if the user account is ever deleted, all their content goes with it - no orphaned records left in the DB.
  #
  #### Or in other words `dependent: :destroy` specifies how deep recursively do you want to delete. "when I'm deleted, also delete these children." - each level has to explicitly opt in. Rails doesn't automatically go deeper than one level — you have to declare it at each step and tell Rails if this level participates or not. 
  #
  # `dependent: :destroy` is used anywhere Rails has an association that owns another record. Associations include: `has_many`, `has_one`, `has_many :through`.
  # `has_many` =>	`has_many :posts, dependent: :destroy` => ✅ Most common — delete user, delete all their posts.
  # `has_one` =>	`has_one :profile, dependent: :destroy` => ✅ Yes — delete user, delete their profile.
  # `has_many :through`	=> `has_many :tags, through: :post_tags, dependent: :destroy`	=> ⚠️ Careful — destroys the tags themselves, not just the join rows.
  # You can't put it on `belongs_to` — that's the child side, it has no "owned" records to destroy. `dependent: :destroy` destroys down, not up to a point. It destroys the children, not the parent. It never flows upward. Deleting a `ResearchItem` does nothing to the `User`.
  # And without `dependent: :destroy`, Rails just deletes the parent and leaves the children sitting in the DB with a `user_id` pointing to a user that no longer exists — those are called orphaned records, and they cause bugs.
  #
  # There are also other options besides :destroy:
    # `dependent: :destroy` => calls .destroy on each child (runs callbacks).
    # `dependent: :delete_all` => skips callbacks, faster but riskier.
    # `dependent: :nullify` => sets the FK to NULL instead of deleting.
    # `dependent: :restrict_with_error` => blocks deletion if children exist.
    # `:nullify` is useful when the child should survive without a parent — e.g. if a `Comment` could exist even after its `Post` is deleted, you'd nullify `post_id` rather than destroy the comment.
  #
  #
  has_many :research_items, dependent: :destroy
  has_many :grant_awards, dependent: :destroy
  has_many :teachings, dependent: :destroy
  has_many :blog_posts, dependent: :destroy

  private

  def single_user_only
    errors.add(:base, "Registration is closed — this site has one account only.") if User.exists?
  end
end
