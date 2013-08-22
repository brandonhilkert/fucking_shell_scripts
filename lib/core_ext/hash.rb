class Hash
  def symbolize_keys_deep!
    keys.each do |k|
      symbol_key_name = k.to_sym
      self[symbol_key_name] = self.delete(k)
      self[symbol_key_name].symbolize_keys_deep! if self[symbol_key_name].kind_of? Hash
    end
    self
  end
end
