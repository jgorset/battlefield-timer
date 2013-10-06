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

    resetTimer = ->
      clearInterval timer
      setTime value.data "default"

    restartTimer = ->
      resetTimer()
      startTimer()

    formatTime = (seconds) ->
      minutes = Math.floor seconds / 60
      seconds = seconds % 60

      if String(minutes).length < 2
        minutes = "0" + minutes

      if String(seconds).length < 2
        seconds = "0" + seconds

      "#{minutes}:#{seconds}"

    setTime = (seconds) ->
      value.data "remaining", seconds
      value.text formatTime seconds

    highlight = ->
      element.addClass("highlight")
      setTimeout (-> element.removeClass("highlight")), 5000

    animateClick = ->
      start.addClass "active"
      setTimeout (-> start.removeClass "active"), 250

    $(document).on "keydown", (event) ->
      if event.keyCode == element.data "hotkey"
        animateClick()
        restartTimer()

    start.on "click", ->
      restartTimer()

    reset.on "click", -> resetTimer()
