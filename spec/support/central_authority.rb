module CentralAuthority
  def guarantee(id)
    Pathname(GEM_ROOT) / "central_authority" / "guarantees" / "#{id}.guarantee.json"
  end

  def expectation(app_name, use_case, guarantee_id)
    Pathname(GEM_ROOT) / "central_authority" / "expectations" / "#{app_name}.#{use_case}.#{guarantee_id}.expectation.json"
  end

  def expectations(guarantee_id)
    Dir[Pathname(GEM_ROOT) / "central_authority" / "expectations" / "*.json"].each do |file|
      expectation = JSON.parse(File.read(file))
      if expectation["guarantee_id"].to_s == guarantee_id.to_s
        yield(expectation)
      else
        puts "#{file} '#{expectation["guarantee_id"]}' doesn't match '#{guarantee_id}'"
      end

    end
  end
end
