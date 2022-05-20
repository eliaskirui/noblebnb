
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "controllers"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.initMap = () => {
    console.log('initMap was called');
    const event = new Event("MapLoaded")
    event.initEvent("map-loaded", true, true);
    window.dispatchEvent(event)
}

















// require("@rais/ujs").start()
// require("@rails/activestorage").start()
// require("channels")
// require("local-time".start)
// require("@hotwired/turbo")
//
// window.initMap = function(...args) {
//     const event = document.createEvent("Events")
//     event.initEvent("google-maps-callback", true, true,)
//     event.args = args
//     window.dispatchEvent(event)
//
// }





// window.Rails = Rails
// import 'data-confirm-modal'
//
// $(document).on("turbo:load", () => {
//     console.log("turbo!")
//     $('[data-toggle="tooltip"]').tooltip()
//     $('[data-toggle="popover"]').popover()
// })