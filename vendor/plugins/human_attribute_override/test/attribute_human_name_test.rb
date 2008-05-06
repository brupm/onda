require 'abstract_unit'
require 'fixtures/customer'

class AttributeHumanNameTest < Test::Unit::TestCase
  fixtures :customers

  def teardown
    Customer.write_inheritable_attribute "attr_human_name", nil
  end
  
  def test_human_name_override
    # no human name overrides defined
    assert_nil Customer.human_name_attributes
    
    # test normal value of human attribute name
    assert_equal 'Address street', Customer.human_attribute_name('address_street')
    
    # override the humanized version
    Customer.attr_human_name 'address_street' => 'Street Address'
    
    # test that we now have the new version of the humanized attribute
    assert_equal 'Street Address', Customer.human_attribute_name('address_street')

    # check the attributes that we've overridden exist
    assert_equal({'address_street' => 'Street Address'}, Customer.human_name_attributes)
  end
end
