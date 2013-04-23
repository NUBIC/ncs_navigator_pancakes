#= require_self
#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require ./router
#= require sjcl
#= require_tree ./routes
#= require fixtures

# SJCL requires the entropy pool to be seeded from some source.  Collectors
# run with the application, but we want to avoid potentially long startup
# delays.  We also need immediate seeding for automated tests.
#
# Therefore, we seed as follows:
#
# 1. The server provides entropy from a CSPRNG and stashes it as a
#    base64-encoded string in #entropy-seed.  (Base64 encoding is used to
#    avoid problems with special HTML tag characters.)  For Pancakes, this
#    means using Ruby's SecureRandom.
#
#    The default paranoia level of SJCL's random number generator (i.e.
#    required entropy) is 256 bits.  We generate 32 bytes' worth from
#    SecureRandom, base64 encode it to avoid problems with e.g. HTML tag
#    characters, and feed it into this.
#
# 2. The application is served over HTTPS to prevent tampering with the
#    generated pool.
Ember.Application.initializer
  name: 'sjcl'

  initialize: (container, application) ->
    pool = $ '#entropy-seed'
    sjcl.random.addEntropy pool.text(), pool.data('estimated-entropy'), 'server'
    sjcl.random.startCollectors()

window.Pancakes = Ember.Application.create()

# vim:ts=2:sw=2:et:tw=78
