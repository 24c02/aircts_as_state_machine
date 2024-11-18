# aircts_as_state_machine
[aasm](https://github.com/aasm/aasm) support for Airrecord tables.

currently only works with my [airrecord fork](https://github.com/24c02/airrecord)

## usage:
don't

but if you must:
```ruby
require "aircts_as_state_machine"

Airrecord.api_key = "pat3verysoftcats"

class Shipment < AirctsAsStateMachine; # instead of Airrecord::Table
  self.base_key = 'appsomething'
  self.table_name = 'tblsomething'
  
  aasm column: "Status" do # Status should be a single-select field in your base
    state :ready, :mailed
    
    event mark_mailed do
      transitions from: :ready, to: :mailed
      before do |postage_cost|
        self["Postage Cost"] = postage_cost
      end
    end
  end
end

x = Shipment.find "recYaself"

# this sets State to "mailed" and Postage Cost to 3.50
x.mark_mailed 3.50
# but nothing persists to the cloud until
x.save

# or...
x["Recipient"] = "nora"
x.mark_mailed! 3.50

# with the !, the transition gets fired in a transaction, so the AASM column 
# and any fields modified in the callbacks are immediately persisted in a single
# PATCH request, but anything modified outside (like Recipient) waits for save.
```

# caveats
i'm trusting this in prod but you probably shouldn't

i wrote this code but i do not understand it

the real horrors are in the """"""[transaction support](https://github.com/24c02/airrecord/blob/5ae56c166b29f4ae2723edce99970e9c8e0d59a3/lib/airrecord/table.rb#L237)"""""" this needed airrecord to have

it's not very good

...

k cya