module CentralAuthority
  def guarantee(id)
    Pathname(GEM_ROOT) / "central_authority" / "guarantees" / "#{id}.guarantee.json"
  end

  def expectation(app_name, use_case, guarantee_id)
    Pathname(GEM_ROOT) / "central_authority" / "expectations" / "#{app_name}.#{use_case}.#{guarantee_id}.expectation.json"
  end
end
