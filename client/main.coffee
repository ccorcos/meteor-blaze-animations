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
      Session.set 'selected', p?._id
      return p


# animations!
Template.leaderboard.rendered = ->
  
  @find(".list")._uihooks =
    insertElement: (node, next) ->
      console.log "insert leaderboard"
      $node = $(node)
      # set the opacity initally to zero
      $node.css('opacity', '0')
      # insert to the dom
      $node.insertBefore(next)
      # animate the opacity
      $node.velocity {opacity: 1},
        duration: 500
        easing: 'ease-in-out'
        queue: false

    moveElement: (node, next) ->
      console.log "move leaderboard"
      $node = $(node)
      $next = $(next)
      $node.insertBefore(next)

    removeElement: (node) ->
      console.log "remove leaderboard"
      $node = $(node)
      # animate off the screen to the left
      $node.velocity {translateX: '-100%'},
        duration: 250
        easing: 'ease-in'
        queue: false
        complete: -> 
          # remove when complete
          $node.remove()



# animations!
Template.layout.rendered = ->

  @find(".yield")._uihooks =
    insertElement: (node, next) ->
      console.log "insert yield"
      $node = $(node)
      if $node.hasClass('leaderboard')
        # initialize the leaderboard to the left
        $.Velocity.hook($node, "translateX", "-100%");
        $node.insertBefore(next)
          .velocity {translateX: '0%'},
            duration: 500
            easing: 'ease-in-out'
            queue: false

      else if $node.hasClass('profile')
        # initialize the profile to the right

        $.Velocity.hook($node, "translateX", "100%");
        $node.insertBefore(next)
          .velocity {translateX: '0%'},
            duration: 500
            easing: 'ease-in-out'
            queue: false

      else
        $node.insertBefore(next)

    removeElement: (node) ->
      console.log "remove yield"
      $node = $(node)
      if $node.hasClass('leaderboard')
        # translate off screen to the left
        $node.velocity {translateX: '-100%'},
          duration: 500
          easing: 'ease-in-out'
          queue: false
          complete: -> 
            # remove when animation is complete
            $node.remove()

      else if $node.hasClass('profile')
        # translate off screen to the right
        $node.velocity {translateX: '100%'},
          duration: 500
          easing: 'ease-in-out'
          queue: false
          complete: -> 
            # remove when animation is complete
            $node.remove()

      else
        $node.remove()

          