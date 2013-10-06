# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $("#timers .timer").each ->
    element = $(this)

    timer = null

    value = element.find ".value"
    start = element.find ".actions .start"
    reset = element.find ".actions .reset"

    channel = pusher.subscribe window.location.hash.replace("#", "")

    channel.bind "restart", (timer) ->
      if timer == element.attr "id"
        animateClick start
        restartTimer()

    channel.bind "reset", (timer) ->
      if timer == element.attr "id"
        animateClick reset
        resetTimer()

    # Broadcast event to this timer across all clients
    #
    # event - A String describing an event.
    broadcast = (event) ->
      $.ajax
        url: "/broadcast"
        type: "POST"
        data:
          channel: channel.name
          event: event
          payload: element.attr "id"
          socket_id: pusher.connection.socket_id

    # Start the timer
    startTimer = ->
      timer = setInterval ->
        seconds = value.data "remaining"

        seconds -= 1

        if seconds <= 0
          element.find(".audio")[0].play()
          highlight()
          resetTimer()
        else
          setTime seconds
      , 1000

    # Reset the timer
    resetTimer = ->
      clearInterval timer
      setTime value.data "default"

    # Reset and start the timer
    restartTimer = ->
      resetTimer()
      startTimer()

    # Format time as mm:ss.
    #
    # seconds - An Integer describing seconds.
    formatTime = (seconds) ->
      minutes = Math.floor seconds / 60
      seconds = seconds % 60

      if String(minutes).length < 2
        minutes = "0" + minutes

      if String(seconds).length < 2
        seconds = "0" + seconds

      "#{minutes}:#{seconds}"

    # Set the time to the given value.
    #
    # seconds - An Integer describing seconds.
    setTime = (seconds) ->
      value.data "remaining", seconds
      value.text formatTime seconds

    # Highlight the timer.
    highlight = ->
      element.addClass("highlight")
      setTimeout (-> element.removeClass("highlight")), 5000

    # Animate the given element so it appears as though clicked.
    #
    # element - A HTML element.
    animateClick = (element) ->
      element = $(element)
      element.addClass "active"
      setTimeout (-> element.removeClass "active"), 250

    $(document).on "keydown", (event) ->
      if event.keyCode == element.data "hotkey"
        start.click()

    start.on "click", ->
      animateClick this
      broadcast "restart"
      restartTimer()

    reset.on "click", ->
      animateClick this
      broadcast "reset"
      resetTimer()
