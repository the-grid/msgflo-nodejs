
debug = require('debug')('msgflo:newrelic')

try
  nr = require 'newrelic'
catch e
  debug 'New Relic not enabled', e.toString()

class Transactions
  constructor: (@name) ->
    @transactions = {}

  open: (id, port) ->
    return if not nr?
    @transactions[id] =
      id: id
      start: Date.now()
      inport: port

  close: (id, port) ->
    return if not nr?
    transaction = @transactions[id]
    if transaction
      duration = Date.now()-transaction.start
      event =
        role: @name
        inport: transaction.inport
        outport: port
        duration: duration
      name = 'MsgfloJobCompleted'
      nr.recordCustomEvent name, event
      debug 'recorded event', name, event
      delete @transactions[id]

exports.Transactions = Transactions
