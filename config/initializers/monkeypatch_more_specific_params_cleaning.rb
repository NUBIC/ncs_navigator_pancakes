# An overly-broad security check introduced in Rails turns this:
# 
#     {"abc":[]}
#
# into (effectively) this:
#
#     {"abc":null}
#
# As you can imagine, this will break a lot things that expect arrays.  See
# https://github.com/rails/rails/issues/8832.
#
# The monkeypatch here is due to Nathan Broadbent:
# https://gist.github.com/ndbroadbent/4758944
module ActionDispatch
  Request.class_eval do
 
    # Remove nils from the params hash
    def deep_munge(hash)
      hash.each do |k, v|
        case v
        when Array
          if v.size > 0 && v.all?(&:nil?)
            hash[k] = nil
            next
          end
          v.grep(Hash) { |x| deep_munge(x) }
          v.compact!
        when Hash
          deep_munge(v)
        end
      end
 
      hash
    end
  end
end
