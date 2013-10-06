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

    start.on "click", ->
      timer = setInterval ->
        value.text value.text() - 1
      , 1000

    reset.on "click", ->
      clearInterval timer
      value.text value.data "default"
