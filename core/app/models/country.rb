class Country < ActiveRecord::Base
  has_many :states
  
  has_one     :zone_member, :as => :zoneable
  has_one     :zone,        :through => :zone_member

  scope :order_by_name, :order => :name  
  validates_presence_of :name, :iso_name
  
  def <=>(other)
    name <=> other.name
  end

  def to_s
    name
  end
end