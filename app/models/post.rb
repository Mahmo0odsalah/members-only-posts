class Post < ApplicationRecord
    belongs_to :member

    validates :text, presence: true, length: {minimum: 10, maximum: 100}
end
