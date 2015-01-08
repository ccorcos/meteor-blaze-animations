Session.setDefault 'selected', null


Template.leaderboard.helpers
  players: () ->
    Players.find {}, {sort: {score: -1, name: 1}}
  selected: -> Session.get 'selected'


Template.leaderboard.events
  'click .toProfile': (e,t) ->
    Router.go 'profile'
  'click .new': (e,t) ->
    Players.insert {name:Fake.word(), score: 0}
  'click .remove': (e,t) ->
    Players.remove Session.get('selected')
  'click .add5': (e,t) ->
    Players.update {_id:Session.get('selected')}, {$inc:{score: 5}}
  

Template.player.helpers
  isSelected: () -> 
    if Session.equals 'selected', @_id
      return 'selected' 
    else
      return ''

Template.player.events
  'click .player': (e,t) ->
    Session.set 'selected', @_id

Template.profile.events
  'click .toLeaderboard': (e,t) ->
    Router.go 'leaderboard'

Template.profile.helpers
  player: () ->
    p = Players.findOne Session.get('selected')
    if p 
      return p
    else
      p = Players.findOne()
      Session.set 'selected', p._id
      return p