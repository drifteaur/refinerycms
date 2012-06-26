require "spec_helper"

ActiveRecord::Schema.define do
  create_table :refinery_crud_dummies, :force => true do |t|
    t.integer :parent_id
    t.integer :lft
    t.integer :rgt
    t.integer :depth
  end
end

module Refinery
  class CrudDummy < ActiveRecord::Base
    attr_accessible :parent_id
    acts_as_nested_set
  end

  class CrudDummyController < ::ApplicationController
    crudify :'refinery/crud_dummy'
  end
end

module Refinery
  describe CrudDummyController, :type => :controller do
    
    describe "#update_positions" do
      before do
        3.times { Refinery::CrudDummy.create! } 
      end

      it "orders dummies" do
        post :update_positions, {"ul"=>{"0"=>{"0"=>{"id"=>"crud_dummy_3"}, "1"=>{"id"=>"crud_dummy_2"}, "2"=>{"id"=>"crud_dummy_1"}}}}
        
        dummies = Refinery::CrudDummy.all
        dummies[0].lft.should eq(5)
        dummies[0].rgt.should eq(6)
        
        dummies[1].lft.should eq(3)
        dummies[1].rgt.should eq(4)
       
        dummies[2].lft.should eq(1)
        dummies[2].rgt.should eq(2)
      end
      
      it "calls rebuild!" do
        Refinery::CrudDummy.should_receive(:rebuild!)

        post :update_positions, {"ul"=>{"0"=>{"0"=>{"id"=>"crud_dummy_1"}}}}
      end  
    end

  end
end
