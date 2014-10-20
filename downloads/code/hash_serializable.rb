module HashSerializable
  def act_as_serializable base, options
    serialize base, Hash

    define_method "#{base}" do             # def auth_info
      # Return empty hash if nil base,      #   read_attribute(:auth_info) || {}
      # and reduce verbose `try` usage      # end
      read_attribute("#{base}") || {}
    end

    define_method "clear_#{base}!" do     # def clear_auth_info!
      send("#{base}=", {})                 #   self.auth_info = {}
      save!                                #   save!
    end                                    # end

    options[:on].each do |attribute|
      attribute = attribute.to_s

      define_method(attribute) do                 # def access_token
        send(base)[attribute]                     #   auth_info["access_token"]
      end                                         # end

      define_method "#{attribute}=" do |value|                  # def access_token= value
        new_base = send(base).merge({ attribute => value })      #   auth_info["access_token"] = value
        # Set new base to trigger Rails field changed event      # end
        send("#{base}=", new_base)
      end

      define_method "#{attribute}?" do                # def access_token?
        send(base)[attribute].present?                 #   auth_info["access_token"].present?
      end                                              # end

      define_method "#{attribute}_changed?" do
        return false unless send("#{base}_changed?")
        send("#{attribute}").presence != send("#{attribute}_was").presence
      end

      define_method "#{attribute}_was" do               # def access_token_was
        (send("#{base}_was") || {})[attribute]           #   (auth_info_was || {})["access_token"]
      end                                                # end

      define_method "remove_#{attribute}!" do           # def remove_access_token!
        send(base).delete(attribute)                     #   auth_info.delete("access_token")
        save!                                            #   save!
      end                                                # end
    end
  end
end
