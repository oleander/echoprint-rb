class AddHookToCodes < ActiveRecord::Migration
  def change
    execute %{
      CREATE RULE "codes_on_duplicate_ignore" AS ON INSERT TO "codes"
        WHERE EXISTS(SELECT 1 FROM codes 
                      WHERE (time, code, track_id)=(NEW.time, NEW.code, NEW.track_id))
        DO INSTEAD NOTHING;
    }
    # INSERT INTO my_table SELECT * FROM another_schema.my_table WHERE some_cond;
    # DROP RULE "my_table_on_duplicate_ignore" ON "my_table";
  end
end
