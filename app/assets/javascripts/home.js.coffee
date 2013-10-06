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
        seconds = value.text()

        if seconds <= 0
          element.find(".audio")[0].play()
          resetTimer()
          return

        value.text seconds - 1
      , 1000

    resetTimer = ->
      clearInterval timer
      value.text value.data "default"

    restartTimer = ->
      resetTimer()
      startTimer()

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
