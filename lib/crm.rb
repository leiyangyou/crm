require File.join(File.dirname(__FILE__), "/crm/has_contract")

ActiveRecord::Base.send :include, CRM::HasContract if defined?(ActiveRecord)
