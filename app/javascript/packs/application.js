require("@rais/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("local-time".start)
require("@hotwired/turbo")

window.Rails = Rails
import 'data-confirm-modal'

$(document).on("turbo:load", () => {
    console.log("turbo!")
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="popover"]').popover()
})